import { IsNotEmpty, IsString } from 'class-validator';

export class BaseVehicleDto {
  @IsNotEmpty()
  @IsString()
  licensePlate: string;
}
