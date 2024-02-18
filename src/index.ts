import express, { Request, Response } from 'express';
import { DBService } from './dbservice.js';
import { logger } from './utils.js';
import AWS from 'aws-sdk';

const PORT = 8080;
const HEALTHCHECK_PORT = 8081;

AWS.config.update({region: process.env.AWS_REGION});

export const businessApp = express();
businessApp.use(express.json());

const dbService = new DBService();

businessApp.get('/api/v1/player/fired_bullets', async (_: Request, res: Response) => {

    try {
        const total = await dbService.getBulletNumber();

        res.json({
            fired_bullet: total
        });
    }
    catch (error) {
        logger.error(`Failed to get fired_bullets: ${error}`);
        res.status(500).json({
            status: "error",
            message: "Failed to get fired_bullets."
        });
    }
});

businessApp.post('/api/v1/player/fired_bullet', (_: Request, res: Response) => {

    try {
        dbService.saveBullet();
        res.json({
            status: "success",
            message: `Bullet received and saved.`
        });
    }
    catch (error) {
        logger.error(`Failed to save bullet: ${error}`);
        res.status(500).json({
            status: "error",
            message: "Failed to save bullet."
        });
    }
});

const healthcheckFunction =  (req: Request, res: Response) => {
    res.json({
        status: "success",
        message: `Server ${process.env.APP_NAME}:${process.env.APP_VERSION} running in ${process.env.AWS_REGION}.`
    });
}
businessApp.get('/ping', healthcheckFunction);

businessApp.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});

// Also listens on 81 for heachcheck
const healthcheckApp = express();
healthcheckApp.use(express.json());

healthcheckApp.get('/ping', healthcheckFunction);

healthcheckApp.listen(HEALTHCHECK_PORT, () => {
    console.log(`Health check server is running on http://localhost:${HEALTHCHECK_PORT}`);
});
