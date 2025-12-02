/**
 * Source Manager - Loads and manages all sources
 */

import { Source } from '../types';

export class SourceManager {
  private sources: Map<string, Source> = new Map();

  /**
   * Register a source
   */
  register(source: Source): void {
    this.sources.set(source.id, source);
  }

  /**
   * Get a source by ID
   */
  getSource(id: string): Source | undefined {
    return this.sources.get(id);
  }

  /**
   * Get all registered sources
   */
  getAllSources(): Source[] {
    return Array.from(this.sources.values());
  }

  /**
   * Find source by domain
   */
  findSourceByDomain(hostname: string): Source | undefined {
    for (const source of this.sources.values()) {
      if (source.domains.some(domain => hostname.includes(domain))) {
        return source;
      }
    }
    return undefined;
  }

  /**
   * Get total sources count
   */
  count(): number {
    return this.sources.size;
  }
}

