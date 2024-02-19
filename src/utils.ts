import winston from 'winston';

export const logger = winston.createLogger({
  level: 'debug',
  format: winston.format.json(),
  transports: [new winston.transports.Console()],
});

process.on('warning', (warning) => {
  if (warning.name === 'DeprecationWarning' && warning.message.includes('AWS SDK for JavaScript (v2)')) {
    // Suppress specific AWS SDK v2 maintenance mode warning
  } else {
    // Use winston to log other warnings
    logger.warn(`${warning.name}: ${warning.message}`);
  }
});
