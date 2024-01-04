import 'package:ccquarters/common/inputs/themed_form_field.dart';
import 'package:ccquarters/common/messages/message.dart';
import 'package:ccquarters/common/widgets/wide_text_button.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, this.email, this.error});

  final String? email;
  final String? error;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final RegExp _emailRegExp =
      RegExp("(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+\$)");
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController.text = widget.email ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).orientation == Orientation.landscape &&
                        MediaQuery.of(context).size.width > 700
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: BackButton(onPressed: () {
              context.read<AuthCubit>().saveEmail(_emailController.text);
              context.read<AuthCubit>().goToLoginPage();
            }),
          ),
          body: _buildInside(context),
        ),
      ),
    );
  }

  Form _buildInside(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: LayoutBuilder(
          builder: (context, constraints) => SizedBox(
            width: constraints.maxWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/graphics/forgot-password.png",
                      height: constraints.maxHeight * 0.25,
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    _buildText(context),
                  ],
                ),
                _buildEmailTextField(context),
                widget.error != null
                    ? _buildError(context)
                    : const SizedBox(
                        height: 20,
                      ),
                _buildButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildText(BuildContext context) {
    return Column(
      children: [
        Text(
          "Zapomniałeś hasła?",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Wpisz swój adres e-mail, a my wyślemy Ci link do zresetowania hasła",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  ConstrainedBox _buildEmailTextField(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width *
            (MediaQuery.of(context).orientation == Orientation.landscape &&
                    MediaQuery.of(context).size.width > 700
                ? 0.4
                : 1),
      ),
      child: ThemedFormField(
        controller: _emailController,
        labelText: "E-mail",
        validator: (text) {
          if (text == null || text.isEmpty) {
            return "Wprowadź adres e-mail";
          }
          if (!_emailRegExp.hasMatch(text)) {
            return "Niepoprawny adres email";
          }
          return null;
        },
      ),
    );
  }

  Padding _buildError(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        "${widget.error!}!",
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }

  WideTextButton _buildButton(BuildContext context) {
    return WideTextButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          context.read<AuthCubit>().resetPassword(_emailController.text);
        }
      },
      text: "Zresetuj hasło",
    );
  }
}

class ForgotPasswordSuccessPage extends StatelessWidget {
  const ForgotPasswordSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width),
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () => context.read<AuthCubit>().goToLoginPage(),
            ),
          ),
          body: Message(
            title: "Wysłano link do zmiany hasła!",
            imageWidget: Image.asset("assets/graphics/check.png"),
          ),
        ),
      ),
    );
  }
}
