export class BulletException extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'BulletException';
  }
}
