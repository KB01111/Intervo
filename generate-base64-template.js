const fs = require('fs');
const path = require('path');

// Read the docker-compose.yml and template.toml files
const dockerComposeContent = fs.readFileSync(path.join(__dirname, 'template', 'docker-compose.yml'), 'utf8');
const templateTomlContent = fs.readFileSync(path.join(__dirname, 'template', 'template.toml'), 'utf8');

// Create the template structure
const template = {
  name: "Intervo AI Platform",
  description: "Complete AI-powered conversation platform with frontend, backend, and RAG API services",
  version: "1.0.0",
  logo: "https://raw.githubusercontent.com/KB01111/Intervo/main/logo.png",
  tags: ["ai", "chat", "conversation", "rag", "nextjs", "nodejs", "python"],
  links: {
    github: "https://github.com/KB01111/Intervo",
    docs: "https://docs.intervo.ai"
  },
  compose: dockerComposeContent,
  template: templateTomlContent
};

// Convert to base64
const base64Template = Buffer.from(JSON.stringify(template, null, 2)).toString('base64');

// Save to file
fs.writeFileSync('intervo-dokploy-template.base64', base64Template);

// Also save the JSON for reference
fs.writeFileSync('intervo-dokploy-template.json', JSON.stringify(template, null, 2));

console.log('✅ Base64 template generated successfully!');
console.log('📁 Files created:');
console.log('  - intervo-dokploy-template.base64 (for Dokploy import)');
console.log('  - intervo-dokploy-template.json (for reference)');
console.log('');
console.log('📋 Base64 Template (copy this for Dokploy import):');
console.log('');
console.log(base64Template);
console.log('');
console.log('🚀 To use this template:');
console.log('1. Copy the base64 string above');
console.log('2. In Dokploy, create a new Compose Service');
console.log('3. Go to Advanced Section → Import Section');
console.log('4. Paste the base64 value and click Import');
console.log('5. Configure your API keys in the environment variables');
console.log('6. Set up your three domains (frontend, backend, rag-api)');
console.log('7. Deploy!');
