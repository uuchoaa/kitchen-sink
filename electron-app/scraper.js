// Script injetado em W1 para fazer scraping
// Este script roda no contexto da página (W1)

(async () => {
  try {
    // Seleciona todos os <p> e pega o segundo (índice 1)
    const paragraphs = document.querySelectorAll('p');
    const targetParagraph = paragraphs[1]; // Segunda tag <p>
    
    if (!targetParagraph) {
      return {
        success: false,
        error: 'Paragraph not found'
      };
    }

    const scrapedData = {
      success: true,
      text: targetParagraph.innerText,
      totalParagraphs: paragraphs.length,
      timestamp: new Date().toISOString()
    };

    // POST to Rails backend
    const response = await fetch('http://localhost:3000/deals/find_or_create', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(scrapedData)
    });

    const apiResponse = await response.json();

    return {
      scrapeData: scrapedData,
      apiResponse: apiResponse,
      success: true
    };
  } catch (error) {
    return {
      success: false,
      error: error.message
    };
  }
})();

