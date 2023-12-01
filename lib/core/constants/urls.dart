const companyApiUrl = 'https://api.cleversell.io/';

const liveApiUrl = 'https://live.airzone.cleversell.io/';

const testApiUrl = 'https://test.airzone.cleversell.io/';

const companyLoginPath = 'companies/login';

const staffListPath = 'staff/_design/getAllStaff/_view/new-view';

const branchesListPath = 'branches/_design/getBranches/_view/new-view';

const loginPath = 'staff/_design/login/_view/new-view';

const roomsListPath = 'rooms/_design/allRooms/_view/new-view';

const customersListPath =
    'users/_design/getByPhone/_view/new-view?%FILTERS%limit=35';

const getCustomerPath =
    'users/_design/getById/_view/new-view?%FILTERS%limit=1';

const addCustomerPath = 'users/';

const checkInPath = 'check_ins/';

const checkOutPath = 'check_outs/';

const checkInDetailsPath = 'check_ins/';

const checkInList = 'check_ins/_design/new-view';

const checkInsLisPath = 'check_ins/_design/all-check-ins/_view/new-view';

const checkOutsLisPath = 'check_outs/_design/all-check-outs/_view/new-view';

// const checkInsListByDatePath = 'check_ins/_design/search-date/_view/new-view';
const checkInsListByDatePath = 'check_ins/_design/new-view/_view/search-date';

const checkOutsListByDatePath = 'check_outs/_design/search-date/_view/new-view';

const bookingsListByDatePath = 'bookings/_design/search-date/_view/new-view';

const serialListPath = 'bookings/_design/calcMaxID/_view/new-view';

const branchSerialListPath = 'bookings/_design/calcMaxID/_view/branch-view';

const bookingStorePath = 'bookings/';

const bookingsListOfRoomPath =
    'bookings/_design/search-date/_view/all-bookings-isDeletedIncluded';

const checkInProductList = 'checkin_products/_design/all-products/_view/all-products';

const ordersOfRangePath = 'bookings/_design/orders/_view/range-view';

const bookingWithoutRoomPath = 'bookings/_design/search-date/_view/all-bookings';

const bookingsListPath = 'bookings/';

const bookingPaymentsPath =
    'bookings/_design/allRoomsTotalPaymentsByBranch/_view/new-view';

const productsOfRoomListPath =
    'products/_design/getProductsOfRoom/_view/new-view';

const addonsListPath = 'add-on-products/_design/allAddonProducts/_view/new-view';

const promoCodesListPath = 'promo/_design/branchPromos/_view/new-view';

const sessionsListPath = 'sessions/_design/getAllSessionsOfRoom/_view/new-view';

const membershipsListPath = 'memberships/_design/getMemberships/_view/new-view';

const shiftForStaffPath = 'shifts/_design/shifts/_view/getOngoingShiftForStaff';

const shiftStorePath = 'shifts/';
