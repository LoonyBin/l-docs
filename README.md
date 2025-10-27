# L Docs

<p align="center">
  <strong>Self-hosted AI-powered document management system</strong>
</p>

L Docs is an open-source, self-hosted application for managing and organizing documents using AI. It's designed to help you efficiently store, search, and manage your personal documents with intelligent automation and powerful search capabilities.

## 🌟 Features

### Current Focus (Personal Documents)
- **AI-Powered Document Processing**: Automatically extract and categorize information from your documents
- **Intelligent Search**: Find documents using natural language queries powered by AI
- **Document Organization**: Automatic tagging and categorization of uploaded documents
- **Self-Hosted**: Complete control over your data and privacy
- **Modern Web Interface**: Fast, responsive UI built with Rails and Turbo
- **Secure Storage**: Your documents stay on your servers

### Roadmap (Enterprise Features)
- Multi-user support with role-based access control
- Advanced collaboration features
- Enterprise-grade security and compliance
- API for third-party integrations
- Custom AI model training for specific use cases

## 🛠 Tech Stack

- **Framework**: Ruby on Rails 8.1
- **Database**: PostgreSQL
- **Frontend**: Turbo + Stimulus (modern, fast, and lightweight)
- **Queue**: Solid Queue (Rails-native background jobs)
- **Cache**: Solid Cache
- **Deployment**: Kamal (zero-downtime deployments)
- **Testing**: RSpec with Capybara
- **Code Quality**: RuboCop, Brakeman, bundler-audit

## 📋 Prerequisites

- Ruby 3.4.7 or higher
- PostgreSQL 9.3 or higher
- Node.js (for asset compilation)
- Docker (for deployment)

## 🚀 Quick Start

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/loonybin/l-docs.git
   cd l-docs
   ```

2. **Install dependencies**:
   ```bash
   bundle install
   ```

3. **Set up the database**:
   ```bash
   bundle exec rails db:create db:migrate
   ```

4. **Start the development server**:
   ```bash
   bundle exec rails server
   ```

   Visit `http://localhost:3000` in your browser.

### Configuration

Copy the example environment file and configure your settings:

```bash
cp .env.example .env
```

Key configuration options:
- `RAILS_MASTER_KEY`: Required for production (found in `config/master.key`)
- `DATABASE_URL`: PostgreSQL connection string (optional, uses `config/database.yml` by default)
- `AI_API_KEY`: Your AI service API key (e.g., OpenAI, Anthropic)

## 🧪 Development

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/document_spec.rb
```

### Code Quality

```bash
# Run RuboCop
bundle exec rubocop

# Run Brakeman (security)
bundle exec brakeman

# Run bundler-audit (dependency security)
bundle exec bundler-audit check --update
```

## 🐳 Docker Deployment

### Using Docker Compose (Recommended)

```bash
docker-compose up
```

### Manual Docker Build

```bash
docker build -t l_docs .
docker run -d -p 80:80 -e RAILS_MASTER_KEY=<your_key> --name l_docs l_docs
```

## 🌐 Production Deployment with Kamal

L Docs is configured for zero-downtime deployments with [Kamal](https://kamal-deploy.org).

1. **Configure your environment variables**:
   Copy `.kamal/secrets.example` to `.kamal/secrets` and configure:
   ```bash
   cp .kamal/secrets.example .kamal/secrets
   ```

2. **Set up your deployment target** in `config/deploy.yml`:
   ```yaml
   servers:
     web:
       - your-server-ip
   ```

3. **Deploy**:
   ```bash
   bundle exec kamal deploy
   ```

### Deployment Configuration

Edit `config/deploy.yml` to configure:
- Server IPs and hosts
- SSL certificates (Let's Encrypt)
- Registry settings
- Environment variables
- Resource allocation

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Write tests for new features
- Follow Ruby style guide (RuboCop)
- Update documentation as needed
- Keep commits atomic and well-described

## 📝 License

### Personal Use - Free of Charge

**L Docs is FREE for personal, non-commercial use** (both free as in freedom and free as in beer):
- ✅ No cost to use, modify, or share
- ✅ Complete access to source code
- ✅ Use for your personal document management
- ✅ Contribute improvements to the community

### Open Source License (AGPL-3.0)

L Docs is released under the **GNU Affero General Public License v3.0 (AGPL-3.0)**. This means:

✅ **Free as in Freedom**:
- You can use, study, modify, and distribute L Docs
- Complete access to source code
- Contribute improvements back to the community

📋 **Requirements**:
- If you modify and deploy L Docs, you must release your modifications under AGPL-3.0
- If you use L Docs in a network service, you must provide source code to users

### Commercial Licensing - Not Free as in Beer

For **commercial use**, **enterprise deployments**, or when AGPL-3.0 requirements are not suitable, commercial licenses are required. Commercial licenses provide:

- ✅ Deployment without AGPL copyleft requirements
- ✅ Proprietary license terms
- ✅ Support and maintenance
- ✅ Priority feature requests

**Commercial licenses are required for**:
- Any commercial or business use
- Enterprise deployments where AGPL is not suitable
- Organizations using L Docs for their business operations
- Products that cannot comply with AGPL-3.0 copyleft provisions
- Organizations requiring proprietary license terms
- Integration into commercial products or services

**Commercial licenses are NOT required for**:
- Personal, non-commercial use
- Individual use for managing your own documents
- Educational or research use (non-commercial)

To obtain a commercial license, contact: **tmayad@loonyb.in** or visit **loonyb.in**

See the [LICENSE](LICENSE) file for full details of the AGPL-3.0 license.

## 💼 Commercial Services

LoonyBin provides professional services for L Docs users and organizations:

### Services We Offer
- **Custom Enterprise Features**: Tailored solutions for specific business needs
- **Deployment & Integration**: Help setting up and integrating L Docs into your infrastructure
- **AI Model Training**: Custom AI models optimized for your specific document types
- **Priority Support**: Direct support from the development team
- **Training & Workshops**: Team training on using and extending L Docs
- **Commercial Licensing**: Enterprise licenses with proprietary terms (see License section above)

### Note on Licensing
Three-tier licensing and services model:
- **Personal use**: Free (both free as in freedom AND free as in beer)
- **Commercial use**: Requires commercial license (not free as in beer)
- **Services**: Hire us for custom development, support, and training (value-added services)

For all commercial inquiries, contact: **tmayad@loonyb.in** or visit **loonyb.in**

## 🗺 Roadmap

- [x] Core application setup
- [x] Database and basic models
- [ ] Document upload and storage
- [ ] AI-powered document processing
- [ ] Intelligent search functionality
- [ ] User authentication
- [ ] Document categorization and tagging
- [ ] Multi-format support (PDF, DOCX, images, etc.)
- [ ] Browser extension for quick document capture
- [ ] Mobile apps (iOS/Android)
- [ ] Enterprise features (multi-user, RBAC, compliance)

## 📧 Contact

- **GitHub Issues**: For bug reports and feature requests
- **Discussions**: For questions and community support
- **Email**: [tmayad@loonyb.in] (for commercial inquiries)

## 🙏 Acknowledgments

Built with open-source technologies and community contributions.

---

Made with ♥ for personal document management
