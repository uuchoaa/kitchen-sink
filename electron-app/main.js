const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');

let linkedinWindow;   // W1
let controlWindow;    // W2

function createWindows() {
  // W1 - LinkedIn Window (será usado para navegação)
  linkedinWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    x: 0,
    y: 0,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js')
    },
    title: 'LinkedIn - W1'
  });

  // Por enquanto carrega HTML estático
  linkedinWindow.loadFile('w1.html');
  // linkedinWindow.webContents.openDevTools();

  // W2 - Control Panel (Rails App)
  controlWindow = new BrowserWindow({
    width: 1000,
    height: 600,
    x: 1220,
    y: 0,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js')
    },
    title: 'Control Panel - W2'
  });

  // Por enquanto carrega HTML estático
  controlWindow.loadFile('w2.html');
  // controlWindow.webContents.openDevTools();

  // Handlers para quando as janelas fecham
  linkedinWindow.on('closed', () => {
    linkedinWindow = null;
  });

  controlWindow.on('closed', () => {
    controlWindow = null;
  });
}

// Quando o Electron estiver pronto
app.whenReady().then(() => {
  createWindows();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindows();
    }
  });
});

// Quit quando todas as janelas forem fechadas (exceto no macOS)
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// IPC Handler: W2 solicita scraping de W1
ipcMain.handle('scrape-w1', async () => {
  try {
    console.log('📡 Received scrape request from W2');
    
    // Injeta script em W1 para fazer o scrape
    const scrapedData = await linkedinWindow.webContents.executeJavaScript(`
      (() => {
        // Seleciona todos os <p> e pega o segundo (índice 1)
        const paragraphs = document.querySelectorAll('p');
        const targetParagraph = paragraphs[1]; // Segunda tag <p>
        
        if (targetParagraph) {
          const text = targetParagraph.innerText;
          
          // Faz o alert em W1
          // alert('📝 Scraped text: ' + text);
          
          return {
            success: true,
            text: text,
            totalParagraphs: paragraphs.length,
            timestamp: new Date().toISOString()
          };
        } else {
          return {
            success: false,
            error: 'Paragraph not found'
          };
        }
      })();
    `);
    
    console.log('✅ Scrape completed:', scrapedData);
    return scrapedData;
    
  } catch (error) {
    console.error('❌ Scrape error:', error);
    return {
      success: false,
      error: error.message
    };
  }
});

