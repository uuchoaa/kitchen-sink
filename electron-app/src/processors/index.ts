/**
 * Processors Registry
 * Import and export all processors here
 */

import { Processor } from '../types';
import { summarizeProcessor } from './summarize';
import { exportJsonProcessor } from './export-json';

// Export all processors as an array
export const allProcessors: Processor[] = [
  summarizeProcessor,
  exportJsonProcessor
  // Add more processors here as they are created
];

