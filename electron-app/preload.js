const { contextBridge, ipcRenderer } = require('electron');

// Expõe API segura para o renderer process
contextBridge.exposeInMainWorld('electronAPI', {
  // Função de teste
  test: () => console.log('Electron API working!'),
  
  // Função para scrape - W2 chama isso
  scrapeW1: () => ipcRenderer.invoke('scrape-w1')
});

console.log('Preload script loaded successfully');

