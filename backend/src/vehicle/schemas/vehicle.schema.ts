import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type VehicleDocument = Vehicle & Document;

@Schema()
export class Vehicle {
  @Prop({ required: true, index: true, unique: true })
  licensePlate: string;

  @Prop()
  status?: string;

  @Prop()
  createdAt: Date;

  @Prop()
  updatedAt?: Date;

  @Prop()
  deletedAt?: Date;
}

export const VehicleSchema = SchemaFactory.createForClass(Vehicle);
