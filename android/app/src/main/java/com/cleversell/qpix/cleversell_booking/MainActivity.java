package com.cleversell.qpix.cleversell_booking;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Bitmap;

//import com.cleversell.qpix.cleversell_booking.R;
import com.fujitsu.fitPrint.Library.FitPrintAndroidLan_v1011.FitPrintAndroidLan;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.util.Log;

import java.lang.reflect.Array;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

import java.util.List;
import java.util.Map;

import android.graphics.drawable.Drawable;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.ColorMatrix;
import android.graphics.Paint;
import android.graphics.Canvas;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Objects;

import android.graphics.Bitmap;
import android.content.res.Resources;

import androidx.annotation.NonNull;


public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.cleversell.qpix.cleversell_booking";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("printInvoice")) {
                                final Map<String, Object> arguments = call.arguments();

                                assert arguments != null;
                                HashMap invoice = (HashMap) arguments.get("invoice");
                                String ip = (String) arguments.get("ip");
                                Map<String, String> params = Map.of("name", "finishedPrintingEvent");
                                Log.d("IP", ip);
                                Log.d("data", String.valueOf(invoice));


                                new Thread(new Runnable() {

                                    @Override
                                    public void run() {
                                        FitPrintAndroidLan printer = new FitPrintAndroidLan();
                                        int response = printer.Connect("192.168.1.11:9100");
                                        // printer.SetFont(true, true, true, true);
                                        Log.d("printerOutput of connect", String.format("value = %d", response));
//                                        assert invoice != null;
//                                        printInvoiceData(printer, invoice);
//                                        printInvoiceData(printer, invoice);
//                                        Log.d("printerOutput of cut paper", String.format("value = %d", response));
                                        printer.Disconnect();
//
//                                        Log.d("is this thing working???", "I certainly hope so");
                                        // Log.d(invoice.get("_id"));
//                                        try {
////                                            JSONObject jsonObject = toJSONObject(invoice);
//                                            JSONObject jsonObject = new JSONObject(invoice);
//
//                                            Log.d("tag", jsonObject.toString(4));
//                                        } catch (JSONException e) {
//                                            Log.e("CLEVERSELL11", "unexpected JSON exception", e);
//                                            // some exception handler code.
//                                        }
                                        // ReactContext
//                                    ReactApplicationContext rc = (ReactApplicationContext) context;
//                                        result.success(params);
//                                    sendEvent(rc, "finishedPrintingEvent", params);
                                    }
                                }).start();
                            }
                        }
                );
    }

    public int printTableRowTwoColumns(FitPrintAndroidLan printer, String left, String right) {
        int nRtn = printText(printer, left, 0);
        // nRtn = printer.PaperFeed(1);
        String columnSpacer = "";
        int leftCharCount = left.length();
        for (int i = 0; i < 36 - leftCharCount; i++) {
            columnSpacer += " ";
        }
        nRtn = printer.PrintText(columnSpacer, "UTF8");

        String rightColumnSpacer = "";
        int rightCharCount = right.length();
        for (int i = 0; i < 8 - rightCharCount; i++) {
            rightColumnSpacer += " ";
        }
        nRtn = printer.PrintText(rightColumnSpacer, "UTF8");

        nRtn = printText(printer, right, 2);
        nRtn = printer.PaperFeed(64);
        return nRtn;
    }

    public int printTableRowThreeColumns(FitPrintAndroidLan printer, String left, String center, String right) {
        int nRtn = printText(printer, left, 0);
        // nRtn = printer.PaperFeed(1);

        String leftColumnSpacer = "";
        int leftCharCount = left.length();
        for (int i = 0; i < 3 - leftCharCount; i++) {
            leftColumnSpacer += " ";
        }
        nRtn = printer.PrintText(leftColumnSpacer, "UTF8");

        nRtn = printer.PrintText(center, "UTF8");

        String centerColumnSpacer = "";
        int centerCharCount = center.length();
        for (int i = 0; i < 33 - centerCharCount; i++) {
            centerColumnSpacer += " ";
        }

        nRtn = printer.PrintText(centerColumnSpacer, "UTF8");

        String rightColumnSpacer = "";
        int rightCharCount = right.length();
        for (int i = 0; i < 8 - rightCharCount; i++) {
            rightColumnSpacer += " ";
        }
        nRtn = printer.PrintText(rightColumnSpacer, "UTF8");

        nRtn = printText(printer, right, 2);
        nRtn = printer.PaperFeed(64);
        return nRtn;
    }

    public int printTableRowThreeColumnsSmallLine(FitPrintAndroidLan printer, String left, String center, String right) {
        int nRtn = printText(printer, left, 0);
        // nRtn = printer.PaperFeed(1);

        String leftColumnSpacer = "";
        int leftCharCount = left.length();
        for (int i = 0; i < 3 - leftCharCount; i++) {
            leftColumnSpacer += " ";
        }
        nRtn = printer.PrintText(leftColumnSpacer, "UTF8");

        nRtn = printer.PrintText(center, "UTF8");

        String centerColumnSpacer = "";
        int centerCharCount = center.length();
        for (int i = 0; i < 33 - centerCharCount; i++) {
            centerColumnSpacer += " ";
        }

        nRtn = printer.PrintText(centerColumnSpacer, "UTF8");

        String rightColumnSpacer = "";
        int rightCharCount = right.length();
        for (int i = 0; i < 8 - rightCharCount; i++) {
            rightColumnSpacer += " ";
        }
        nRtn = printer.PrintText(rightColumnSpacer, "UTF8");

        nRtn = printText(printer, right, 2);
        nRtn = printer.PaperFeed(32);
        return nRtn;
    }

    public int printText(FitPrintAndroidLan printer, String text, int alignment) {
        int nRtn = printer.SetAlignment(alignment);
        if (alignment == 0) {
            nRtn = printer.PrintText("  ", "UTF8");
        }
        nRtn = printer.PrintText(text, "UTF8");
        if (alignment == 2) {
            // nRtn = printer.PrintText(" ", "UTF8");
        }
        return nRtn;
    }

    public int printLine(FitPrintAndroidLan printer, String text, int alignment) {
        int nRtn = printText(printer, text, alignment);
        nRtn = printer.PaperFeed(64);
        return nRtn;
    }

//    public Bitmap doInBackground() {
//        Resources res = context.getResources();
//        String mDrawableName = "logohome";
//        Drawable drawable = res.getDrawable(R.drawable.logohome);
//        BitmapDrawable bitmapDrawable = ((BitmapDrawable) drawable);
//        Bitmap bitmap = bitmapDrawable.getBitmap();
//        // bitmap = Bitmap.createScaledBitmap(bitmap, 435, 241, false);
//        // bitmap = invert(bitmap);
//        return bitmap;
//    }

    int printPaymentSerial(FitPrintAndroidLan printer, List<HashMap> paid) {
        int nRtn = 0;
        if (paid.size() > 0) {
            String serial = paid.get(paid.size() - 1).get("serial") != null ? (String) paid.get(paid.size() - 1).get("serial")
                    : null;
            if (serial != null) {
                nRtn = printLine(printer, "#" + serial, 1);
            }
        }

        return nRtn;
    }

    public String capitalizeFirstLetter(String original) {
        if (original == null || original.length() == 0) {
            return original;
        }
        return original.substring(0, 1).toUpperCase() + original.substring(1);
    }

    int printPaymentMethod(FitPrintAndroidLan printer, List<HashMap> paid) {
        int nRtn = 0;
        if (paid.size() > 0) {
            String method = paid.get(paid.size() - 1).get("method") != null ? (String) paid.get(paid.size() - 1).get("method")
                    : null;
            if (method != null) {
                nRtn = printLine(printer, capitalizeFirstLetter(method), 1);
            }
        }

        return nRtn;
    }

    int printProductAddons(FitPrintAndroidLan printer, List productAddons) {
        int nRtn = printer.SetAlignment(0);

        if (productAddons != null && productAddons.size() > 0) {
            for (int i = 0; i < productAddons.size(); i++) {
                HashMap productAddon = (HashMap) productAddons.get(i);
                String productAddonName = (String) productAddon.get("name");
                String leftSpacer = "";
                for (int j = 0; j < 5; j++) {
                    leftSpacer += " ";
                }
                printer.PrintText(leftSpacer, "UTF8");
                printer.PrintText(productAddonName, "UTF8");
                printer.PaperFeed(32);
            }
        }

        return nRtn;
    }

    int printProduct(FitPrintAndroidLan printer, HashMap product, Double quantity) {
        String productName = "";
        String productPrice = "";
        List productAddons = product.get("adds") != null ? (List) product.get("adds") : null;
        if (product.get("name") != null && product.get("price") != null) {
            productName = (String) product.get("name");
            productPrice = (String) product.get("price");
        }

        assert productPrice != null;
        Double priceTotal = quantity * Double.parseDouble(productPrice);

        int nRtn = printTableRowThreeColumnsSmallLine(printer, String.format("%.0f", quantity), productName,
                String.format("%.2f", priceTotal));

        nRtn = printProductAddons(printer, productAddons);

        nRtn = printer.PaperFeed(32);

        return nRtn;
    }

    @SuppressLint("DefaultLocale")
    Double printAddonProducts(FitPrintAndroidLan printer, HashMap addOns, Double total) {
        int nRtn = 0;
        for (int i = 0; i < addOns.size(); i++) {
            HashMap addOn = (HashMap) addOns.get(i);
            assert addOn != null;
            String type = (String) addOn.get("quantity");
            Double addonQuntity = 0.0;
            Log.d("TYPE", type.toString());
            addonQuntity = (Double) addOn.get("quanitty");

            Double addonTotal = addonQuntity * Double.parseDouble((String) Objects.requireNonNull(addOn.get("price")));

            nRtn = printTableRowThreeColumns(printer, String.format("%.0f", addonQuntity), (String) addOn.get("name"),
                    String.format("%.2f", addonTotal));

            total += addonTotal;
        }

        return total;
    }

    @SuppressLint("DefaultLocale")
    int printBookingData(FitPrintAndroidLan printer, HashMap booking) {
        HashMap branch = (HashMap) booking.get("branch");
        String branchName = (String) branch.get("name");
        HashMap customer = (HashMap) booking.get("user");
        String customerName = (String) customer.get("name");
        String customerPhone =(String)  customer.get("phone");

        String bookingDate = (String) booking.get("date");
        String bookingTime = (String) booking.get("time");
        String currentDate = (String) booking.get("currentDate");
        String currentTime = (String) booking.get("currentTime");
        HashMap product = (HashMap) booking.get("product");
        HashMap addOns = booking.get("addOns") != null ? (HashMap) booking.get("addOns") : null;

        boolean isRefund = booking.containsKey("isRefund") ? (boolean) booking.get("isRefund") : false;
        String productName = "";
        Double productQuantity = 0.0;
        String type = (String) booking.get("quantity");
        Log.d("TYPE", type.toString());
        productQuantity = (Double) booking.get("quantity");
        String productPrice = product.containsKey("price") ? (String) product.get("price") : "0";

        Double total = Double.parseDouble(productPrice) * productQuantity;

        String promoPercentage = "";
        Double promoValue = 0.00;
        HashMap promo = booking.get("promo") != null ? (HashMap) booking.get("promo") : null;
        if (promo != null) {
            promoPercentage = promo.get("value") != null ? (String) promo.get("value") : "0.00";

            promoValue = (total * Double.parseDouble(promoPercentage)) / 100;
            promoValue = Math.floor(promoValue / 5) * 5;
        }

        String paidTotal = "400.00";

        List<HashMap> paid = booking.get("paid") != null ? (List<HashMap>) booking.get("paid") : null;
        Double paymentSum = 0.00;
        if (paid != null & paid.size() > 0) {
            for (int i = 0; i < paid.size(); i++) {
                HashMap payment = paid.get(i);
                Double amount = (Double) payment.get("amount");
                paymentSum += amount;
            }
        }

        paidTotal = paymentSum + "";

        String bookingId = (String) booking.get("_id");

        String bookingType = booking.get("type") != null ? (String) booking.get("type") : "Booking";
        String refund = isRefund ? bookingType + " Refund" : bookingType;

        int nRtn = printer.SetAlignment(1);
        nRtn = printer.PrintText("   ", "UTF8");
//        nRtn = printer.PrintImage(doInBackground());
        nRtn = printer.PaperFeed(64);
        nRtn = printLine(printer, branchName, 1);
        nRtn = printLine(printer, refund, 1);

        nRtn = printer.PrintQrCode(customerPhone, 1, 6, true, 0);
        nRtn = printer.PaperFeed(64);
        nRtn = printLine(printer, customerName, 1);
        nRtn = printLine(printer, customerPhone, 1);
        nRtn = printPaymentMethod(printer, paid);
        nRtn = printLine(printer, "------------------------------", 1);

        nRtn = printTableRowTwoColumns(printer, String.format("Current Time: %s - %s", currentDate, currentTime), "");
        nRtn = printLine(printer, "------------------------------", 1);
        nRtn = printTableRowTwoColumns(printer, String.format("%s Date: %s - %s", bookingType, bookingDate, bookingTime),
                "");
        nRtn = printLine(printer, "===============================", 1);
        nRtn = printProduct(printer, product, productQuantity);

        if (addOns != null && addOns.size() > 0) {
            total = printAddonProducts(printer, addOns, total);
        }

        Double totalAfterDiscount = (total - promoValue);
        Double remaining = (total - promoValue - paymentSum);
        nRtn = printLine(printer, "------  ", 2);
        nRtn = printTableRowTwoColumns(printer, "Total", String.format("%.2f", total));
        if (promoValue > 0) {
            nRtn = printTableRowTwoColumns(printer, "Discount", String.format("%.2f", promoValue));
            nRtn = printTableRowTwoColumns(printer, "Total After Discount", String.format("%.2f", totalAfterDiscount));
        }
        if (remaining > 0) {
            nRtn = printLine(printer, "------  ", 2);
            nRtn = printTableRowTwoColumns(printer, "Paid", String.format("%.2f", paymentSum));
            nRtn = printTableRowTwoColumns(printer, "Remaining", String.format("%.2f", remaining));
        }
        nRtn = printLine(printer, "===============================", 1);

        nRtn = printLine(printer, "Prices include Taxes", 1);

        // TODO: Set Account Legal Financial Info dynamically
        nRtn = printLine(printer, "CrNo.193591 / TaxCardNo.699-452-074", 1);
        nRtn = printLine(printer, "80645", 1);
        nRtn = printPaymentSerial(printer, paid);
        nRtn = printer.PrintBarcode(4, bookingId, 2, 0, 2, 100);
        nRtn = printer.PaperFeed(128);
        nRtn = printer.CutPaper(1);

        return nRtn;
    }

    int printOrderDetails(FitPrintAndroidLan printer, HashMap order) {
        HashMap branch = (HashMap) order.get("branch");
        String branchName = (String) branch.get("name");

        HashMap customer = (HashMap) order.get("user");
        String customerName = (String) customer.get("name");
        String customerPhone = (String) customer.get("phone");

        String bookingDate = (String) order.get("date");
        String bookingTime = (String) order.get("time");
        String currentDate = (String) order.get("currentDate");
        String currentTime = (String) order.get("currentTime");
        HashMap addOns = order.get("addOns") != null ? (HashMap) order.get("addOns") : null;
        boolean isRefund = order.containsKey("isRefund") && (boolean) order.get("isRefund");

        Double total = 0.0;

        String paidTotal = "400.00";

        List paid = order.get("paid") != null ? (List) order.get("paid") : null;
        Double paymentSum = 0.00;
        assert paid != null;
        if (paid != null & paid.size() > 0) {
            for (int i = 0; i < paid.size(); i++) {
                HashMap payment = (HashMap) paid.get(i);
                Double amount = (Double) payment.get("amount");
                paymentSum += amount;
            }
        }

        paidTotal = paymentSum + "";

        String bookingId = (String) order.get("_id");

        String bookingType = (String) order.get("type");
        String refund = isRefund ? bookingType + " Refund" : bookingType;

        int nRtn = printer.SetStandardMode();
        nRtn = printer.SetLocale(8);
        nRtn = printer.SetAlignment(1);
        nRtn = printer.PrintText("   ", "UTF8");
        // nRtn = printer.PrintImage(doInBackground());
        nRtn = printer.PaperFeed(64);
        nRtn = printLine(printer, branchName, 1);
        nRtn = printLine(printer, refund, 1);

        nRtn = printer.PrintQrCode(customerPhone, 1, 6, true, 0);
        nRtn = printer.PaperFeed(64);
        nRtn = printLine(printer, customerName, 1);
        nRtn = printLine(printer, customerPhone, 1);
        nRtn = printPaymentMethod(printer, paid);
        nRtn = printLine(printer, "------------------------------", 1);
        nRtn = printTableRowTwoColumns(printer, String.format("Current Time: %s - %s", currentDate, currentTime), "");
        nRtn = printLine(printer, "------------------------------", 1);
        nRtn = printTableRowTwoColumns(printer, String.format("Order Date: %s", bookingDate), "");
        nRtn = printLine(printer, "===============================", 1);

        if (addOns != null && addOns.size() > 0) {

            total = printAddonProducts(printer, addOns, total);
        }
        Double remaining = (total - paymentSum);

        // TODO: Show only the information that are applicable
        nRtn = printLine(printer, "------  ", 2);
        nRtn = printTableRowTwoColumns(printer, "Total", String.format("%.2f", total));
        if (remaining > 0) {
            nRtn = printLine(printer, "------  ", 2);
            nRtn = printTableRowTwoColumns(printer, "Paid", String.format("%.2f", paymentSum));
            nRtn = printTableRowTwoColumns(printer, "Remaining", String.format("%.2f", remaining));
        }
        nRtn = printLine(printer, "===============================", 1);

        nRtn = printLine(printer, "Prices include Taxes", 1);

        // TODO: Set Account Legal Financial Info dynamically
        nRtn = printLine(printer, "CrNo.88384 / TaxCardNo.425519121", 1);
        nRtn = printLine(printer, "80645", 1);
        nRtn = printPaymentSerial(printer, paid);
        nRtn = printer.PrintBarcode(4, bookingId, 2, 0, 2, 100);
        nRtn = printer.PaperFeed(128);
        nRtn = printer.CutPaper(1);

        return nRtn;
    }

    public void printInvoiceData(FitPrintAndroidLan printer, HashMap invoice) {

        Boolean isOrder = invoice.containsKey("isOrder") ? (Boolean) invoice.get("isOrder") : false;

        if (isOrder != null && isOrder) {
            printOrderDetails(printer, invoice);
        } else {
            printBookingData(printer, invoice);
        }
    }
}
