import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:synapsis/env.dart';
import 'package:flutter/material.dart';
import 'package:synapsis/framework/managers/helper.dart';
import 'package:synapsis/framework/widgets/loading_indicator.dart';
import 'package:synapsis/utils/colors.dart';
import 'package:synapsis/service_locator.dart';
import 'package:synapsis/utils/text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synapsis/config/global_vars.dart';
import 'package:synapsis/config/string_resource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:synapsis/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:synapsis/features/auth/presentation/bloc/auth_event.dart';
import 'package:synapsis/features/login/presentation/bloc/bloc/login_bloc.dart';
import 'package:synapsis/features/login/presentation/bloc/bloc/login_event.dart';
import 'package:synapsis/features/login/presentation/bloc/bloc/login_state.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);
  SharedPreferences prefs = serviceLocator.get<SharedPreferences>();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool obscureText = false;
  bool isLoading = false;

  String? username;
  String? password;

  @override
  void initState() {
    if (Env().isInDebugMode) {
      username = Env().demoUsername;
      password = Env().demoPassword;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginSubmitting) {
          final progress = ProgressHUD.of(context);
          progress?.showWithText(
              GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);
          setState(() {});
        } else if (state is LoginSuccess) {
          final progress = ProgressHUD.of(context);
          progress!.dismiss();
          BlocProvider.of<AuthBloc>(context).add(
            LoggedIn(loggedInData: state.success),
          );
          isLoading = false;
          setState(() {});
        } else if (state is LoginFailure) {
          catchAllException(context, state.message, true);
          final progress = ProgressHUD.of(context);
          progress!.dismiss();
          setState(() {});
        }
      },
      child: isLoading
          ? const LoadingPage()
          : Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: (MediaQuery.of(context).size.height / 20) + 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        GlobalConfiguration()
                                .getValue(GlobalVars.TEXT_TITLE_LOGIN) ??
                            StringResources.TEXT_TITLE_LOGIN,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                          fontSize: 21,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    FormBuilder(
                      key: _formKey,
                      child: Theme(
                        data: ThemeData(
                          inputDecorationTheme: InputDecorationTheme(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Color(0xffCCCED3)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0xffE0E0E0),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0xffF05454),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0xffE0E0E0),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintStyle:
                                const TextStyle(color: Color(0xffD1D5DB)),
                            labelStyle:
                                const TextStyle(color: Color(0xffD1D5DB)),
                            errorStyle: const TextStyle(color: Colors.red),
                            filled: true,
                            fillColor: const Color(0xffE5E5E5).withOpacity(0.5),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  GlobalConfiguration()
                                          .getValue(GlobalVars.TEXT_EMAIL) ??
                                      StringResources.TEXT_EMAIL,
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.normal,
                                    color: AppColors.greyColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              FormBuilderTextField(
                                // ignore: unnecessary_null_in_if_null_operators
                                initialValue: username ?? null,
                                onChanged: (val) {
                                  setState(() {
                                    username = val;
                                  });
                                },
                                name: 'username',
                                decoration: InputDecoration(
                                  labelText: GlobalConfiguration().getValue(
                                          GlobalVars.TEXT_HINT_EMAIL) ??
                                      StringResources.TEXT_HINT_EMAIL,
                                  labelStyle: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.normal,
                                    color: AppColors.greyColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  GlobalConfiguration().getValue(
                                          GlobalVars.TEXT_LABEL_PASSWORD) ??
                                      StringResources.TEXT_LABEL_PASSWORD,
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.normal,
                                    color: AppColors.greyColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              FormBuilderTextField(
                                // ignore: unnecessary_null_in_if_null_operators
                                initialValue: password ?? null,
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                                obscureText: obscureText ? false : true,
                                name: 'password',
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(
                                          () => obscureText = !obscureText);
                                    },
                                    icon: obscureText
                                        ? SvgPicture.asset(
                                            "assets/icons/eye.svg")
                                        : SvgPicture.asset(
                                            "assets/icons/eye-slash.svg"),
                                  ),
                                  labelText: GlobalConfiguration().getValue(
                                          GlobalVars.TEXT_LABEL_PASSWORD) ??
                                      StringResources.TEXT_HINT_PASSWORD,
                                  labelStyle: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  prefixIcon: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: SvgPicture.asset(
                                      'assets/icons/lock-circle.svg',
                                      color: const Color(0xff969696),
                                    ),
                                  ),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.minLength(
                                    5,
                                    errorText: GlobalConfiguration().getValue(
                                            GlobalVars
                                                .TEXT_ERROR_PASSWORD_MIN) ??
                                        StringResources.TEXT_ERROR_PASSWORD_MIN,
                                  ),
                                ]),
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.06,
                                    height: MediaQuery.of(context).size.width *
                                        0.06,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.greyColor,
                                        width: 1.5,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    GlobalConfiguration().getValue(
                                            GlobalVars.TEXT_REMEMBER) ??
                                        StringResources.TEXT_REMEMBER,
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontStyle: FontStyle.normal,
                                      color: AppColors.greyColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 50),
                                width: MediaQuery.of(context).size.width,
                                child: FloatingActionButton.extended(
                                  onPressed: () {
                                    if (_formKey.currentState!
                                        .saveAndValidate()) {
                                      BlocProvider.of<LoginBloc>(context)
                                          .add(LoginWithCredentialsPressed(
                                        username: username!,
                                        password: password!,
                                      ));
                                      isLoading = false;
                                    }
                                  },
                                  label: Text(
                                    GlobalConfiguration().getValue(
                                            GlobalVars.BUTTON_LOGIN) ??
                                        StringResources.BUTTON_LOGIN,
                                    style: whiteTextstyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: bold,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: AppColors.primaryColor,
                                  elevation: 0,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  GlobalConfiguration()
                                          .getValue(GlobalVars.TEXT_OR) ??
                                      StringResources.TEXT_OR,
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.normal,
                                    color: AppColors.primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                    width: 1.5,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: FloatingActionButton.extended(
                                  onPressed: () {
                                    if (_formKey.currentState!
                                        .saveAndValidate()) {
                                      BlocProvider.of<LoginBloc>(context)
                                          .add(LoginWithCredentialsPressed(
                                        username: username!,
                                        password: password!,
                                      ));
                                      isLoading = false;
                                    }
                                  },
                                  label: Text(
                                    GlobalConfiguration().getValue(
                                            GlobalVars.BUTTON_FINGER_PRINT) ??
                                        StringResources.BUTTON_FINGER_PRIN,
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: bold,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: AppColors.whiteTextColor,
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
    );
  }
}
