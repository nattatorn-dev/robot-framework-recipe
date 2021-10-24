import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreateVehicleDto } from './dto/create-vehicle.dto';
import { UpdateVehicleDto } from './dto/update-vehicle.dto';
import { Vehicle, VehicleDocument } from './schemas/vehicle.schema';

enum Status {
  Active = 'Active',
  Inactive = 'Inactive',
}

@Injectable()
export class VehicleService {
  constructor(
    @InjectModel(Vehicle.name) private readonly model: Model<VehicleDocument>,
  ) {}

  async findAll(): Promise<Vehicle[]> {
    return await this.model.find({ status: Status.Active }).exec();
  }

  async findOne(id: string): Promise<Vehicle> {
    const vehicle = await this.model
      .findOne({ _id: id, status: Status.Active })
      .exec();

    if (vehicle) {
      return vehicle;
    }

    throw new NotFoundException(`Vehicle with id '${id}' not found`);
  }

  async create(createVehicleDto: CreateVehicleDto): Promise<void> {
    const found = await this.model.findOne({
      licensePlate: createVehicleDto.licensePlate,
    });

    if (found) {
      throw new BadRequestException(
        `Vehicle with licensePlate '${createVehicleDto.licensePlate}' already exist`,
      );
    }

    try {
      const vehicle = new this.model({
        ...createVehicleDto,
        createdAt: new Date(),
        status: Status.Active,
      });
      await vehicle.save();
    } catch (error) {
      throw new InternalServerErrorException(error);
    }
  }

  async update(
    id: string,
    updateVehicleDto: UpdateVehicleDto,
  ): Promise<Vehicle> {
    const found = await this.model.findOne({
      _id: id,
    });

    if (!found) {
      throw new NotFoundException(`Vehicle with id '${id}' not found`);
    }

    try {
      const vehicle = this.model.findByIdAndUpdate(id, updateVehicleDto);
      return await vehicle.exec();
    } catch (error) {
      throw new InternalServerErrorException(error);
    }
  }

  async delete(id: string): Promise<void> {
    const found = await this.model.findOne({
      _id: id,
    });

    if (!found || (found && found.status === Status.Inactive)) {
      throw new NotFoundException(`Vehicle with id '${id}' not found`);
    }

    try {
      const vehicle = this.model.findByIdAndUpdate(id, {
        status: Status.Inactive,
      });
      await vehicle.exec();
    } catch (error) {
      throw new InternalServerErrorException(error);
    }
  }
}
