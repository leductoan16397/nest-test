import 'reflect-metadata';
import { Controller, Get, Logger, Module } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';

@Controller()
class AppController {
  @Get('/health')
  index(): { status: string } {
    return { status: 'ok' };
  }
}

@Module({ controllers: [AppController] })
class AppModule {}

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create(AppModule);
  /* SIGTERM/SIGINT -> app.close(), PM2 chờ theo kill_timeout trong pm2.json */
  app.enableShutdownHooks();
  app.setGlobalPrefix('api');
  const port = Number(process.env.PORT ?? 3334);
  await app.listen(port);
  new Logger('Bootstrap').log(`Application is running on: http://localhost:${port}`);
}

void bootstrap();
