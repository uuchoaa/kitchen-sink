/**
 * Simple URL store to remember last visited URL
 */

import * as fs from 'fs';
import * as path from 'path';
import { app } from 'electron';

interface StoreData {
  lastUrl?: string;
  lastVisited?: string;
}

export class UrlStore {
  private filePath: string;
  private data: StoreData;

  constructor() {
    const userDataPath = app.getPath('userData');
    this.filePath = path.join(userDataPath, 'url-store.json');
    this.data = this.load();
  }

  private load(): StoreData {
    try {
      if (fs.existsSync(this.filePath)) {
        const content = fs.readFileSync(this.filePath, 'utf-8');
        return JSON.parse(content);
      }
    } catch (error) {
      console.error('Error loading URL store:', error);
    }
    return {};
  }

  private save(): void {
    try {
      fs.writeFileSync(this.filePath, JSON.stringify(this.data, null, 2));
    } catch (error) {
      console.error('Error saving URL store:', error);
    }
  }

  getLastUrl(): string | null {
    return this.data.lastUrl || null;
  }

  setLastUrl(url: string): void {
    // Don't save local file URLs (welcome page)
    if (url.startsWith('file://')) {
      return;
    }
    
    this.data.lastUrl = url;
    this.data.lastVisited = new Date().toISOString();
    this.save();
  }

  clear(): void {
    this.data = {};
    this.save();
  }
}

