import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/article.dart';
import '../../providers/news_provider.dart';
import '../../utils/helpers.dart';
import '../../widgets/adaptive_image.dart';

class AdminCreateArticleScreen extends StatefulWidget {
  final Article? article;

  const AdminCreateArticleScreen({super.key, this.article});

  @override
  State<AdminCreateArticleScreen> createState() =>
      _AdminCreateArticleScreenState();
}

class _AdminCreateArticleScreenState extends State<AdminCreateArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _summaryController;
  late TextEditingController _imageUrlController;
  late TextEditingController _tagsController;
  String _selectedCategory = 'politics';
  bool _isPublished = true;
  bool _isBreaking = false;

  bool get isEditing => widget.article != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article?.title ?? '');
    _contentController =
        TextEditingController(text: widget.article?.content ?? '');
    _summaryController =
        TextEditingController(text: widget.article?.summary ?? '');
    _imageUrlController = TextEditingController(
        text: widget.article?.imageUrl ??
            'https://images.unsplash.com/photo-1504711434969-e33886168d6c?w=800');
    _tagsController =
        TextEditingController(text: widget.article?.tags.join(', ') ?? '');
    if (widget.article != null) {
      _selectedCategory = widget.article!.categoryId;
      _isPublished = widget.article!.isPublished;
      _isBreaking = widget.article!.isBreaking;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _summaryController.dispose();
    _imageUrlController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _save({bool asDraft = false}) {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<NewsProvider>();
    final categories = provider.categories;
    final category =
        categories.firstWhere((c) => c.id == _selectedCategory);

    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final article = Article(
      id: isEditing
          ? widget.article!.id
          : 'new_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      summary: _summaryController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
      categoryId: _selectedCategory,
      categoryName: category.name,
      authorName: 'Admin User',
      authorAvatar: 'https://i.pravatar.cc/150?img=70',
      source: 'QuickPrepAI News',
      publishedAt: DateTime.now(),
      readTimeMinutes: (_contentController.text.length / 1000).ceil().clamp(1, 30),
      isPublished: asDraft ? false : _isPublished,
      isBreaking: _isBreaking,
      tags: tags,
    );

    if (isEditing) {
      provider.updateArticle(article);
    } else {
      provider.addArticle(article);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          asDraft
              ? 'Article saved as draft'
              : isEditing
                  ? 'Article updated successfully'
                  : 'Article published successfully',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = context
        .watch<NewsProvider>()
        .categories
        .where((c) => c.id != 'all')
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isEditing ? 'Edit Article' : 'Create Article'),
        actions: [
          TextButton(
            onPressed: () => _save(asDraft: true),
            child: const Text('Save Draft'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image URL
              TextFormField(
                controller: _imageUrlController,
                validator: (v) => Validators.required(v, 'Image URL'),
                decoration: const InputDecoration(
                  labelText: 'Featured Image URL',
                  prefixIcon: Icon(Icons.image),
                ),
              ),
              const SizedBox(height: 12),
              // Preview image
              if (_imageUrlController.text.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AdaptiveImage(
                    imagePath: _imageUrlController.text,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: Container(
                      height: 180,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Center(
                          child: Text('Failed to load image')),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Title
              TextFormField(
                controller: _titleController,
                validator: (v) => Validators.required(v, 'Title'),
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Article Title',
                  hintText: 'Enter a compelling headline...',
                ),
              ),
              const SizedBox(height: 16),
              // Summary
              TextFormField(
                controller: _summaryController,
                validator: (v) => Validators.required(v, 'Summary'),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Summary',
                  hintText: 'Brief summary of the article...',
                ),
              ),
              const SizedBox(height: 16),
              // Category dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                ),
                items: categories
                    .map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 16),
              // Tags
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                  hintText: 'AI, Technology, Research',
                  prefixIcon: Icon(Icons.tag),
                ),
              ),
              const SizedBox(height: 16),
              // Content
              Text('Article Content', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contentController,
                validator: (v) => Validators.required(v, 'Content'),
                maxLines: 12,
                decoration: const InputDecoration(
                  hintText: 'Write your article content here...\n\nSupports multiple paragraphs.',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              // Switches
              SwitchListTile(
                value: _isPublished,
                onChanged: (v) => setState(() => _isPublished = v),
                title: const Text('Publish immediately'),
                secondary: const Icon(Icons.publish),
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                value: _isBreaking,
                onChanged: (v) => setState(() => _isBreaking = v),
                title: const Text('Mark as Breaking News'),
                secondary: const Icon(Icons.flash_on),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              // Publish button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: Icon(isEditing ? Icons.save : Icons.publish),
                  label: Text(isEditing ? 'Update Article' : 'Publish Article'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
