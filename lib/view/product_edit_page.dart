import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_app/controllers/product_controller.dart';
import 'package:market_app/models/product_model.dart';
import 'package:market_app/utils/routes.dart';
import 'package:provider/provider.dart';

class ProductEditPage extends StatefulWidget {
  const ProductEditPage({super.key});

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final _descriptionFocus = FocusNode();
  final _priceFocus = FocusNode();

  final _imageUrl = FocusNode();
  final _imageUrlController = TextEditingController();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageUrlController.addListener(updateImage);
  }

  @override
  void dispose() {
    _descriptionFocus.dispose();
    _priceFocus.dispose();

    _imageUrlController.removeListener(updateImage);
    _imageUrlController.dispose();
    _imageUrl.dispose();

    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate();

    if (!isValid!) {
      return;
    }

    _formKey.currentState?.save();

    Provider.of<ProductListController>(context, listen: false).editProductFromData(_formData);
    Navigator.of(context).pushNamed(Routes.HOME);
  }

  @override
  Widget build(BuildContext context) {
    final ProductModel specificProduct = ModalRoute.of(context)?.settings.arguments as ProductModel;

    if (_formData["id"] == null) {
      _formData["id"] = specificProduct.id;
      _titleController.text = specificProduct.title;
      _priceController.text = specificProduct.price.toString();
      _descriptionController.text = specificProduct.description;
      _imageUrlController.text = specificProduct.imageUrl;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Editar Produto",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _submitForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Título do Produto"),
                controller: _titleController,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocus),
                onSaved: (title) => _formData["title"] = title ?? "",
                validator: (_title) {
                  final title = _title ?? "";

                  if (title.trim().isEmpty && title == specificProduct.title) {
                    return "Título igual ao anterior, alteração obrigatória!";
                  }

                  if (title.trim().length < 3) {
                    return "Título deve ter pelo menos 3 caracteres!";
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Preço do Produto"),
                controller: _priceController,
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocus),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                onSaved: (price) => _formData["price"] = double.parse(price ?? "0"),
                validator: (_price) {
                  final price = _price ?? "0";

                  if (price.trim().isEmpty) {
                    return "Insira um preço!";
                  }

                  if (double.parse(price.trim()) <= 0) {
                    return "Insira um preço válido!";
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Descrição do Produto"),
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocus,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(),
                onSaved: (description) => _formData["description"] = description ?? "",
                validator: (_description) {
                  final description = _description ?? "";

                  if (description.trim().isEmpty) {
                    return "Insira uma descrição!";
                  }

                  if (description.trim().length < 10) {
                    return "Descrição deve ter pelo menos 10 caracteres!";
                  }

                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: "Url do Produto"),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrl,
                      controller: _imageUrlController,
                      onSaved: (imageUrl) => _formData["imageUrl"] = imageUrl ?? "",
                      onFieldSubmitted: (_) => _submitForm(),
                      validator: (_imageUrl) {
                        final imageUrl = _imageUrl ?? "";

                        if (imageUrl.trim().isEmpty) {
                          return "Insira uma URL!";
                        }

                        if (!Uri.parse(imageUrl).isAbsolute) {
                          return "Insira uma URL válida!";
                        }

                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? const Text("URL da imagem")
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(_imageUrlController.text),
                          ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}