import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  ValidationPipe,
} from '@nestjs/common';
import { IsMongoId } from 'class-validator';
import { CreateVehicleDto } from './dto/create-vehicle.dto';
import { UpdateVehicleDto } from './dto/update-vehicle.dto';
import { VehicleService } from './vehicle.service';

export class ObjectId {
  @IsMongoId()
  readonly id: string;
}

@Controller('vehicles')
export class VehicleController {
  constructor(private readonly service: VehicleService) {}

  @Get()
  async index() {
    return await this.service.findAll();
  }

  @Get(':id')
  async find(@Param(ValidationPipe) objectId: ObjectId) {
    return await this.service.findOne(objectId.id);
  }

  @Post()
  async create(@Body() createVehicleDto: CreateVehicleDto) {
    return await this.service.create(createVehicleDto);
  }

  @Put(':id')
  async update(
    @Param(ValidationPipe) objectId: ObjectId,
    @Body() updateVehicleDto: UpdateVehicleDto,
  ) {
    return await this.service.update(objectId.id, updateVehicleDto);
  }

  @Delete(':id')
  async delete(@Param(ValidationPipe) objectId: ObjectId) {
    return await this.service.delete(objectId.id);
  }
}
