import process from 'process';
import { logger } from './utils.js';
import { FiredBullets } from './interfaces.js';
import { Redis } from 'ioredis';

export class DBService {
  private client: Redis;

  constructor() {
    this.client = new Redis({
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT || '6379'),
      password: process.env.DB_PASSWORD,
      username: "default",
      tls: {
        servername: process.env.DB_HOST
      }
    });

    this.client.on('connect', () => {
      console.log('Redis connection established.');
    });

    this.client.on('error', err => {
      console.error('Redis connection error', err);
    });
  }

  async getBulletNumber(): Promise<FiredBullets> {
    try {
      const fired_bullets = await this.client.get('fired_bullets');
      if (fired_bullets === null) {
        throw new Error('Failed to get bullet number.');
      }
      else {
        return {fired_bullets: parseInt(fired_bullets)};
      }
    } catch (error) {
      logger.error(`Failed to get bullet number: ${error}`);
      throw error;
    }
  }

  async saveBullet(): Promise<void> {
    try {
      await this.client.incr('fired_bullets');
    } catch (error) {
      logger.error(`Failed to save bullet: ${error}`);
      throw error;
    }
  }
}
