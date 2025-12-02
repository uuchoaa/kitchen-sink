/**
 * Action Executor - Executes readers and writers by injecting scripts
 */

import { BrowserWindow } from 'electron';
import { Reader, Writer, ExecutionResult } from '../types';

export class ActionExecutor {
  /**
   * Execute a reader on a browser window
   */
  async executeReader(
    window: BrowserWindow,
    reader: Reader,
    sourceId: string,
    scenarioId: string
  ): Promise<ExecutionResult> {
    try {
      const url = window.webContents.getURL();
      const data = await window.webContents.executeJavaScript(reader.script);

      return {
        success: true,
        data,
        timestamp: new Date().toISOString(),
        actionId: reader.id,
        actionName: reader.name,
        scenarioId,
        sourceId,
        url
      };
    } catch (error: any) {
      return {
        success: false,
        error: error.message,
        timestamp: new Date().toISOString(),
        actionId: reader.id,
        actionName: reader.name,
        scenarioId,
        sourceId,
        url: window.webContents.getURL()
      };
    }
  }

  /**
   * Execute a writer on a browser window
   */
  async executeWriter(
    window: BrowserWindow,
    writer: Writer,
    sourceId: string,
    scenarioId: string,
    inputData?: any
  ): Promise<ExecutionResult> {
    try {
      const url = window.webContents.getURL();
      
      // Inject input data as a global variable before executing the script
      let scriptWithData = writer.script;
      if (inputData !== undefined) {
        scriptWithData = `
          (function() {
            const __INPUT_DATA__ = ${JSON.stringify(inputData)};
            ${writer.script}
          })();
        `;
      }

      const data = await window.webContents.executeJavaScript(scriptWithData);

      return {
        success: true,
        data,
        timestamp: new Date().toISOString(),
        actionId: writer.id,
        actionName: writer.name,
        scenarioId,
        sourceId,
        url
      };
    } catch (error: any) {
      return {
        success: false,
        error: error.message,
        timestamp: new Date().toISOString(),
        actionId: writer.id,
        actionName: writer.name,
        scenarioId,
        sourceId,
        url: window.webContents.getURL()
      };
    }
  }

  /**
   * Test a reader/writer script on a local HTML file
   */
  async testScript(
    window: BrowserWindow,
    script: string,
    htmlPath: string
  ): Promise<any> {
    // Load the test fixture
    await window.loadFile(htmlPath);
    
    // Execute the script
    const result = await window.webContents.executeJavaScript(script);
    return result;
  }
}

