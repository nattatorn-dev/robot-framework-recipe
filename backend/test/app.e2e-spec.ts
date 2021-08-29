import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { VehicleController } from 'src/vehicle/vehicle.controller';

describe('AppController (e2e)', () => {
  let app: INestApplication;

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [VehicleController],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  it('/ (POST)', () => {
    return request(app.getHttpServer())
      .post('/users')
      .expect(201)
      .expect('Hello World!');
  });
});
