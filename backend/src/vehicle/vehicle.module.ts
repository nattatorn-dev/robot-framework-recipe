import { Module } from '@nestjs/common';
import { VehicleService } from './vehicle.service';
import { VehicleController } from './vehicle.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { Vehicle, VehicleSchema } from './schemas/vehicle.schema';

@Module({
  providers: [VehicleService],
  controllers: [VehicleController],
  imports: [
    MongooseModule.forFeature([{ name: Vehicle.name, schema: VehicleSchema }]),
  ],
})
export class VehicleModule {}
