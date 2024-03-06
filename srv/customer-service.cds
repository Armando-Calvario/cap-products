using { com.alfa as alfa } from '../db/schema';

service CustomerService {

    entity CustomerSrv AS projection ON alfa.Customer;

}