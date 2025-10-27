<!-- 8732b622-f185-45fd-8436-b7ebf4c8ce51 349b1000-6f16-4007-9539-0fa9d59cb29e -->
# AI-Powered Document Management System

## User Experience Flow

1. **Home Screen**: Split view with folder tree (left) and upload zone (top), upload history sidebar (right)
2. **Upload**: User drops files → AI processes → auto-organizes into folders with tags
3. **Review**: Upload history shows recent uploads with AI-assigned metadata for review/editing
4. **Browse**: Folder tree shows organized documents, clicking shows document details
5. **Edit**: All tags, metadata, and folder assignments are editable; documents can be copied/moved

## Database Schema & Models

### Core Models

**Document**

- `title:string` (AI-generated or from filename)
- `description:text` (AI-extracted summary)
- `document_type:string` (AI-classified: "invoice", "letter", "receipt", etc.)
- `variant_type:string` (e.g., "plain", "signed", "signed_and_stamped")
- `parent_document_id:integer` (for variants)
- `metadata:jsonb` (AI-extracted key-value pairs)
- `ai_confidence:float` (0-1 score for AI classification accuracy)
- `ai_processing_status:string` (pending, processing, completed, failed)
- Associations: has_many :versions, has_many :document_paths, has_many :tags (through document_tags)

**DocumentVersion**

- `document_id:integer`
- `version_number:integer` (auto-increment)
- `version_name:string` (optional named version)
- `notes:text`
- `file_metadata:jsonb` (size, mime_type, checksum, etc.)
- `upload_batch_id:integer` (groups files uploaded together)
- Active Storage: has_one_attached :file
- Associations: belongs_to :document, belongs_to :upload_batch

**DocumentPath** (virtual folder system)

- `document_id:integer`
- `path:string` (e.g., "Personal/Financial/Tax Returns/2025")
- `is_primary:boolean` (one primary path per document)
- `position:integer` (for ordering within folder)
- Indexes: path (for efficient folder queries)
- Associations: belongs_to :document

**Tag**

- `name:string` (indexed, unique)
- `tag_type:string` ("simple", "key_value", "folder")
- `key:string` (for key-value tags)
- `value:string` (for key-value tags)
- `usage_count:integer` (denormalized for autocomplete)
- Associations: has_many :documents (through document_tags)

**DocumentTag** (join table)

- `document_id:integer`
- `tag_id:integer`
- `ai_generated:boolean` (track if AI or user added)
- `confidence:float` (if AI-generated)
- Composite index: [document_id, tag_id]

**UploadBatch**

- `status:string` (uploading, processing, completed, failed)
- `total_files:integer`
- `processed_files:integer`
- `ai_context:jsonb` (stores AI's understanding of file relationships)
- `created_at:datetime`
- Associations: has_many :document_versions

## AI Integration Layer

### Service Architecture

```
app/services/
  ai/
    openai_client.rb              # OpenAI API wrapper
    document_analyzer.rb          # Main AI orchestrator
    metadata_extractor.rb         # Extract metadata from documents
    folder_organizer.rb           # AI suggests folder paths
    tag_generator.rb              # Generate relevant tags
    relationship_detector.rb      # Detect related documents in batch
    text_extractor.rb            # Extract text from various formats
```

### AI Processing Pipeline

1. **Text Extraction**: Extract text from uploaded file (PDF, images, docs)
2. **Document Analysis**: Send to OpenAI (GPT-4 or GPT-4 Vision for images/PDFs)
3. **Metadata Extraction**: Extract title, type, date, entities, summary
4. **Folder Assignment**: AI suggests folder path based on content and existing structure
5. **Tag Generation**: Generate relevant tags (simple and key-value)
6. **Relationship Detection**: Check if uploaded files are related/variants
7. **Store Results**: Save with confidence scores for user review

### Prompts (Opinionated Structure)

- **System Prompt**: Defines folder taxonomy for personal documents (Financial, Legal, Medical, Personal, Work, etc.)
- **Analysis Prompt**: Template for extracting structured metadata
- **Folder Prompt**: Guidelines for consistent folder naming and hierarchy
- Future: User-editable prompts stored in database

## Controllers & Routes

```ruby
# Home/Dashboard
root 'dashboard#index'

# Upload endpoint with AI processing
resources :uploads, only: [:create, :index, :show] do
  member do
    post :reprocess  # Re-run AI analysis
  end
end

# Document management
resources :documents do
  resources :versions, only: [:index, :show, :create]
  member do
    patch :update_metadata
    patch :update_tags
    post :copy
    patch :move
    get 'download/:format', to: 'documents#download'
  end
  collection do
    get :search
  end
end

# Folder navigation
get '/folders/*path', to: 'folders#show', as: :folder
post '/folders', to: 'folders#create'

# Tag management
resources :tags, only: [:index, :show, :create, :update, :destroy]
```

### Key Controllers

**DashboardController**

- `index` - Main view: folder tree + upload zone + upload history

**UploadsController**

- `create` - Handle file uploads, trigger AI processing
- `index` - Upload history list
- `show` - Upload batch details with AI results
- `reprocess` - Re-run AI analysis with different parameters

**DocumentsController**

- `show` - Document details with versions, tags, paths
- `update_metadata` - Edit AI-extracted metadata
- `update_tags` - Add/remove/edit tags
- `copy` - Copy document to additional folder paths
- `move` - Move primary path, can move or copy secondary paths
- `search` - Full-text and metadata search

**FoldersController**

- `show` - Display documents in folder path
- `create` - Create new folder path

## Background Jobs

**ProcessUploadBatchJob**

- Orchestrates AI processing for upload batch
- Extracts text from files
- Calls AI services in sequence
- Updates progress in real-time (via Turbo Streams)
- Priority: high (user is waiting)

**AnalyzeDocumentJob**

- Process single document through AI pipeline
- Can be re-queued for reprocessing
- Stores results with confidence scores

**ConvertDocumentJob**

- Format conversion (PDF, images, text)
- Caching of converted versions
- Priority: low (on-demand)

**RelationshipDetectionJob**

- Run after batch processing
- Detect variants and related documents
- Suggest links to user

## Format Conversion (Pluggable)

```
app/services/converters/
  base_converter.rb
  pdf_converter.rb       # Various formats → PDF
  image_converter.rb     # PDF/docs → images
  text_converter.rb      # Extract plain text
  converter_factory.rb
```

## UI Components & Views

### Main Layout (HAML)

```
layouts/
  application.html.haml  # Main layout with sidebar
  _folder_tree.html.haml # Recursive folder tree component
  _upload_zone.html.haml # Drag-drop upload area
```

### Dashboard

```
dashboard/
  index.html.haml        # Main dashboard view
  _upload_sidebar.html.haml  # Upload history sidebar
```

### Documents

```
documents/
  show.html.haml         # Document details with inline editing
  _metadata_form.html.haml
  _tag_editor.html.haml
  _version_list.html.haml
  _path_manager.html.haml  # Manage folder paths
```

### Folders

```
folders/
  show.html.haml         # Folder contents view
  _document_grid.html.haml
```

### Upload History

```
uploads/
  index.html.haml        # Full upload history
  show.html.haml         # Batch details with AI decisions
  _batch_item.html.haml  # Individual file in batch
```

### Stimulus Controllers (JavaScript)

```javascript
// File upload with progress and Turbo Streams
upload_controller.js
// Drag-drop for file upload
dropzone_controller.js
// Inline tag editing with autocomplete
tag_editor_controller.js
// Inline metadata editing
metadata_editor_controller.js
// Folder tree navigation and expansion
folder_tree_controller.js
// Document path management (copy/move)
path_manager_controller.js
// Real-time upload processing updates
upload_status_controller.js
```

## Configuration

### Environment Variables

```
OPENAI_API_KEY=xxx
OPENAI_MODEL=gpt-4o-mini          # Cheaper model for text
OPENAI_VISION_MODEL=gpt-4o        # For image/PDF analysis (as needed)
OPENAI_MAX_TOKENS=2000
AI_PROCESSING_TIMEOUT=30          # seconds
```

### Active Storage

- Local filesystem for development/test
- S3-compatible for production (configured in `config/storage.yml`)

## Testing Strategy

### Model Tests

- Document associations (paths, tags, versions)
- DocumentPath queries (folder navigation)
- Tag creation and types
- Version auto-numbering
- Upload batch lifecycle

### Service Tests (Critical)

- AI client integration (use VCR for recording API calls)
- Metadata extraction accuracy
- Folder path generation
- Tag generation
- Text extraction from various formats

### Controller Tests

- Upload flow with AI processing
- Document metadata updates
- Tag management
- Path copy/move operations
- Folder navigation

### System Tests (Capybara)

- Complete upload → AI processing → review → edit flow
- Folder navigation and document browsing
- Upload history interaction
- Tag editing with autocomplete
- Document copy/move between folders

### Test Fixtures

- Sample PDFs, images, documents for AI processing
- VCR cassettes for OpenAI API responses
- Factory for documents with realistic AI-generated metadata

## Implementation Phases

### Phase 1: Foundation (Models & Basic Upload)

1. Create migrations for all models
2. Set up Active Storage
3. Basic upload without AI (manual metadata entry)
4. Document versioning
5. Folder path system (CRUD)
6. Tag system (simple and key-value)

### Phase 2: AI Integration

7. OpenAI client setup
8. Text extraction service
9. Document analyzer service
10. Metadata extraction
11. Folder path suggestion
12. Tag generation
13. Background job processing

### Phase 3: UI & UX

14. Dashboard layout with folder tree
15. Upload zone with drag-drop
16. Upload history sidebar with Turbo Streams
17. Document detail view with inline editing
18. Folder navigation
19. Tag autocomplete and editor
20. Path management (copy/move)

### Phase 4: Format Conversion

21. Converter infrastructure
22. PDF converter
23. Image converter
24. Text extractor
25. Caching system

### Phase 5: Polish & Features

26. Relationship detection (variants)
27. Advanced search
28. Batch operations
29. AI reprocessing
30. Performance optimization
31. Comprehensive testing

## Key Files to Create

### Migrations (11 files)

- `create_documents.rb`
- `create_document_versions.rb`
- `create_document_paths.rb`
- `create_tags.rb`
- `create_document_tags.rb`
- `create_upload_batches.rb`
- `install_active_storage.rb`

### Models (6 files)

- `document.rb`
- `document_version.rb`
- `document_path.rb`
- `tag.rb`
- `document_tag.rb`
- `upload_batch.rb`

### AI Services (7 files)

- `ai/openai_client.rb`
- `ai/document_analyzer.rb`
- `ai/metadata_extractor.rb`
- `ai/folder_organizer.rb`
- `ai/tag_generator.rb`
- `ai/relationship_detector.rb`
- `ai/text_extractor.rb`

### Converters (5 files)

- `converters/base_converter.rb`
- `converters/pdf_converter.rb`
- `converters/image_converter.rb`
- `converters/text_converter.rb`
- `converters/converter_factory.rb`

### Jobs (4 files)

- `process_upload_batch_job.rb`
- `analyze_document_job.rb`
- `convert_document_job.rb`
- `relationship_detection_job.rb`

### Controllers (5 files)

- `dashboard_controller.rb`
- `uploads_controller.rb`
- `documents_controller.rb`
- `folders_controller.rb`
- `tags_controller.rb`

### Views (~20 files)

- Dashboard, uploads, documents, folders, shared components

### JavaScript (~8 files)

- Stimulus controllers for interactive features

### Tests (~30 files)

- Model, service, controller, system specs

## Dependencies to Add

```ruby
# Gemfile additions
gem "ruby-openai"              # OpenAI API client
gem "pdf-reader"               # PDF text extraction
gem "rtesseract"               # OCR (future)
gem "mini_magick"              # Image processing
gem "vcr"                      # Record HTTP interactions for tests
gem "webmock"                  # Mock HTTP requests in tests
```

## Notes

- **AI First**: Every upload goes through AI pipeline, but results are always editable
- **Opinionated Folders**: AI follows predefined taxonomy for personal docs (Financial, Medical, Legal, etc.)
- **Confidence Tracking**: Store AI confidence scores to highlight uncertain classifications
- **Upload History = Review Interface**: Doubles as audit trail and correction mechanism
- **Multiple Paths**: Documents can live in multiple folders (virtual links via DocumentPath)
- **Cost Optimization**: Use cheaper GPT-4o-mini for text, GPT-4o only when vision needed
- **Future-Ready**: Prompt system designed to be user-editable later
- **Relationship Detection**: AI analyzes upload batches to detect related files/variants
- **Real-time Updates**: Turbo Streams for live upload processing feedback

### To-dos

- [ ] Create database migrations and models (Document, DocumentVersion, Tag, DocumentTag)
- [ ] Configure Active Storage for local and S3-compatible storage
- [ ] Set up routes and basic controllers (Documents, Versions, Tags)
- [ ] Implement document upload functionality (UI and API endpoints)
- [ ] Build versioning system with auto and named versions
- [ ] Implement tagging system (simple tags and key-value pairs)
- [ ] Create format converter base classes and factory pattern
- [ ] Implement PDF, Image, and Text converters with caching
- [ ] Set up background job processing for format conversions
- [ ] Build UI views and Stimulus controllers for document management
- [ ] Write comprehensive test coverage (models, controllers, services, system tests)
- [ ] Create API documentation and usage guides