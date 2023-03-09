import 'package:cleversell_booking/core/controller/booking_controller.dart';
import 'package:cleversell_booking/core/controller/branch_auth_controller.dart';
import 'package:cleversell_booking/core/controller/check_in_controller.dart';
import 'package:cleversell_booking/core/controller/check_out_controller.dart';
import 'package:cleversell_booking/core/controller/company_auth_controller.dart';
import 'package:cleversell_booking/core/controller/order_controller.dart';
import 'package:cleversell_booking/core/controller/staff_auth_controller.dart';
import 'package:cleversell_booking/core/data/repository/addon_product_repository.dart';
import 'package:cleversell_booking/core/data/repository/booking_repository.dart';
import 'package:cleversell_booking/core/data/repository/branch_repository.dart';
import 'package:cleversell_booking/core/data/repository/check_in_repository.dart';
import 'package:cleversell_booking/core/data/repository/company_repository.dart';
import 'package:cleversell_booking/core/data/repository/order_repository.dart';
import 'package:cleversell_booking/core/data/repository/product_repository.dart';
import 'package:cleversell_booking/core/data/repository/promo_code_repository.dart';
import 'package:cleversell_booking/core/data/repository/staff_repository.dart';
import 'package:cleversell_booking/screens/bookings_screen.dart';
import 'package:cleversell_booking/screens/branch_auth_screen.dart';
import 'package:cleversell_booking/screens/check_ins_screen.dart';
import 'package:cleversell_booking/screens/check_outs_screen.dart';
import 'package:cleversell_booking/screens/company_auth_screen.dart';
import 'package:cleversell_booking/screens/dashboard_screen.dart';
import 'package:cleversell_booking/screens/orders_screen.dart';
import 'package:cleversell_booking/screens/staff_auth_screen.dart';
import 'package:get/get.dart';
import 'package:cleversell_booking/core/constants/route_names.dart';
import 'package:cleversell_booking/core/controller/splash_controller.dart';
import 'package:cleversell_booking/screens/splash_screen.dart';

import '../controller/dashboard_controller.dart';
import '../data/repository/customer_repository.dart';

final CompanyRepository _companyRepository = CompanyRepository();
final BranchRepository _branchRepository = BranchRepository();
final StaffRepository _staffRepository = StaffRepository();
final BookingRepository _bookingRepository = BookingRepository();
final CustomerRepository _customerRepository = CustomerRepository();
final ProductRepository _productRepository = ProductRepository();
final OrderRepository _orderRepository = OrderRepository();
final PromoCodeRepository _promoCodeRepository = PromoCodeRepository();
final AddonProductRepository _addonProductRepository = AddonProductRepository();
final CheckInRepository _checkInRepository = CheckInRepository();

final List<GetPage> routes = [
  GetPage(name: splashRoute, page: () => SplashScreen(SplashController())),
  GetPage(name: companyAuthRoute, page: () => CompanyAuthScreen(CompanyAuthController(_companyRepository))),
  GetPage(name: staffAuthRoute, page: () => StaffAuthScreen(StaffAuthController(_staffRepository))),
  GetPage(name: branchAuthRoute, page: () => BranchAuthScreen(BranchAuthController(_branchRepository))),
  GetPage(name: dashboardRoute, page: () => DashboardScreen(DashboardController(_bookingRepository,
      _customerRepository,_productRepository,_promoCodeRepository,_addonProductRepository,
      _branchRepository,_staffRepository,_checkInRepository))),
  GetPage(name: bookingsRoute, page: () => BookingsScreen(BookingsController(_bookingRepository))),
  GetPage(name: ordersRoute, page: () => OrdersScreen(OrdersController(_orderRepository))),
  GetPage(name: checkInsRoute, page: () => CheckInsScreen(CheckInController(_checkInRepository))),
  GetPage(name: checkOutsRoute, page: () => CheckOutsScreen(CheckOutController(_checkInRepository))),
];
