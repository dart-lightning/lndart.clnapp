import 'package:clnapp/model/app_model/get_info.dart';
import 'package:clnapp/model/app_model/list_funds.dart';
import 'package:clnapp/model/app_model/list_transaction.dart';
import 'package:clnapp/model/app_model/pay_invoice.dart';
import 'package:clnapp/model/app_model/generate_invoice.dart';
import 'package:clnapp/model/app_model/decode_invoice.dart';
import 'package:clnapp/model/app_model/list_peers.dart';
import 'package:clnapp/model/app_model/newaddr.dart';
import 'package:clnapp/model/app_model/withdraw.dart';
import 'package:clnapp/model/app_model/bkpr_listincome.dart';
import 'package:clnapp/model/app_model/appinfo_with_income.dart';

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

  /// Return the pay response from lightning node.
  Future<AppPayInvoice> payInvoice({required String invoice, int? msat});

  /// Return a bolt 11/12 invoice
  Future<AppGenerateInvoice> generateInvoice(String label, String description,
      {int? amount});

  /// For decoding the invoice
  Future<AppDecodeInvoice> decodeInvoice(String invoice);

  /// For checking the status of node
  Future<AppListPeers> listPeers(String id);

  /// For generating new address
  Future<AppNewAddr> newAddr();

  Future<AppWithdraw> withdraw(
      {required String destination, required int mSatoshi});

  Future<AppListIncome> listincome();

  /// Gets the information for getinfo as well as list income
  Future<AppInfoWithIncome> getInfoWithIncome();
}
