import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_app/controllers/product_controller.dart';
// import 'package:market_app/utils/routes.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descFocus = FocusNode();

  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageUrlController.addListener(updateImage);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceFocus.dispose();
    _descFocus.dispose();

    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate();

    if (!isValid!) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<ProductListController>(context, listen: false)
          .addProductFromData(_formData);

      Navigator.of(context).pop();
    } catch (error) {
      // ignore: use_build_context_synchronously
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Erro ao registrar produto!"),
          content: const Text(
              "Ocorreu um erro ao salvar o produto! Tente outra vez."),
          actions: [
            TextButton(
                child: const Text("Ok"),
                onPressed: () => Navigator.of(context).pop)
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Formulário de Produtos",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _submitForm,
          )
        ],
        backgroundColor: Colors.purple,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(35.0),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Nome"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_priceFocus),
                        onSaved: (title) => _formData["title"] = title ?? "",
                        validator: (_name) {
                          final name = _name ?? "";

                          if (name.trim().isEmpty) {
                            return "Nome é obrigatório!";
                          }

                          if (name.trim().length < 3) {
                            return "Nome precisa de no mínimo 3 caracteres!";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 50),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Preço"),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocus,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_descFocus),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d*')),
                        ],
                        onSaved: (price) =>
                            _formData["price"] = double.parse(price ?? "0"),
                        validator: (_price) {
                          final price = _price ?? "0";

                          if (price.trim().isEmpty) {
                            return "Insira um preço!";
                          }

                          if (double.parse(price.trim()) < 0) {
                            return "Insira um preço válido!";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 50),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: "Descrição"),
                        textInputAction: TextInputAction.next,
                        focusNode: _descFocus,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_imageUrlFocus),
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        onSaved: (description) =>
                            _formData["description"] = description ?? "",
                        validator: (_description) {
                          final description = _description ?? "";

                          if (description.trim().isEmpty) {
                            return "Descrição é obrigatória";
                          }

                          if (description.trim().length < 10) {
                            return "Descrição precisa ter no mínimo 10 caracteres";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  labelText: "Url da Imagem"),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFocus,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) => _submitForm(),
                              onSaved: (imageUrl) =>
                                  _formData["imageUrl"] = imageUrl ?? "",
                              validator: (_imageUrl) {
                                final imageUrl = _imageUrl ?? "";

                                if (imageUrl.trim().isEmpty) {
                                  return "Url é obrigatória!";
                                }

                                if (!Uri.parse(imageUrl).isAbsolute) {
                                  return "Insira uma Url válida!";
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
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: _imageUrlController.text.isEmpty
                                ? const Text("Url da Imagem")
                                : Image.network(_imageUrlController.text),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
