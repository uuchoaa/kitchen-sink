/**
 * Sources Registry
 * Import and export all sources here
 */

import { Source } from '../types';
import { linkedinSource } from './linkedin/source';
import { calendlySource } from './calendly/source';

// Export all sources as an array
export const allSources: Source[] = [
  linkedinSource,
  calendlySource
  // Add more sources here as they are created
];

