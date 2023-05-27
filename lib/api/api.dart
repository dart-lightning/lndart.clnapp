import 'package:clnapp/model/app_model/get_info.dart';
import 'package:clnapp/model/app_model/list_funds.dart';
import 'package:clnapp/model/app_model/list_invoices.dart';
import 'package:clnapp/model/app_model/list_transaction.dart';
import 'package:clnapp/model/app_model/pay_invoice.dart';

import 'package:clnapp/model/app_model/list_send_pays.dart';

import 'package:clnapp/model/app_model/generate_invoice.dart';

/// App API implementation, the class contains all the information
/// to make a call to core lightning and return the correct type
/// of useful of the UI.
///
/// author: https://github.com/vincenzopalazzo

/// This is an abstract class of the API interface
/// useful to implement different type use case,
/// like a MockAPI that can be used
/// to develop demo app, or UI testing
abstract class AppApi {
  /// Return all the information of the node
  /// throw a cln getinfo call
  Future<AppGetInfo> getInfo();

  /// Return the list of transaction from lightning node.
  Future<AppListTransactions> listTransaction();

  /// Return the list of funds from lightning node.
  Future<AppListFunds?> listFunds();

  /// Return the list of invoices from lightning node.
  Future<AppListInvoices> listInvoices({String? status});

  /// Return the pay response from lightning node.
  Future<AppPayInvoice> payInvoice({required String invoice, int? msat});

  /// Return the list of payments that succeeded
  Future<AppListSendPays> listSendPays();

  /// Return a bolt 11/12 invoice
  Future<AppGenerateInvoice> generateInvoice(String label, String description,
      {int? amount});
}
