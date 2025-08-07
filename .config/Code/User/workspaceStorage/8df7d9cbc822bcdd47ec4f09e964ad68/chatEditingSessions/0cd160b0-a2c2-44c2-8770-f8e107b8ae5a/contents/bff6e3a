import CustomError from '../utils/errors';
import { Request, Response, NextFunction } from 'express';
import { validationResult, ValidationChain } from 'express-validator';
import { z } from 'zod';

export const validate = (validations: ValidationChain[]) => {
  return async (
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      await Promise.all(validations.map((validation) => validation.run(req)));

      const errors = validationResult(req);

      if (!errors.isEmpty()) {
        const error = new CustomError({
          message: `Validation error: ${errors
            .array()
            .map((err) => `${err.type}: ${err.msg}`)
            .join(', ')}`,
          statusCode: 400,
        });
        next(error);
      } else {
        next();
      }
    } catch (error) {
      next(error);
    }
  };
};

export const validateSchema = (schema: z.ZodSchema) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    try {
      schema.parse(req.body);
      next();
    } catch (error) {
      if (error instanceof z.ZodError) {
        const validationError = new CustomError({
          message: `Validation error: ${error.issues
            .map((err) => `${err.path.join('.')}: ${err.message}`)
            .join(', ')}`,
          statusCode: 400,
        });
        next(validationError);
      } else {
        next(error);
      }
    }
  };
};
