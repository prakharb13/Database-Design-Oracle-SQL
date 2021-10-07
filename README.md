# Database-Design-Oracle-SQL
DDL Script to create a fully functioning demo of the Hotel Reservation System database.

Entity Relationship Diagram of the database is shown below:
![image](https://user-images.githubusercontent.com/25415975/136294964-cc108bf5-57a6-49cc-9d94-95ff3504fc85.png)

## Constraints to Follow
1. Assign primary and foreign keys per the design.
2. Only the following can be NULL: Address_line_2 since it’s not required. Customers’ birthdates since it’s not always known. The reservation Checkout Date, Discount Code, Customer Rating, and Notes are also not required since they are allowed to be blank when the reservation is created. 
3. The following fields should be UNIQUE: Customer email, Feature Name, Location Name, Reservation, and Confirmation Number. 

DEFAULTS:
  1. Stay credits earned and used should be set initially to 0 (zero).
  2. The reservation Date_Created should default to the current date using the SYSDATE function. 
  3. Make sure the following Check constraints are added:
      1. Reservation status as of now can only be the following values detailed above: U, I, C, N, or R.  
      2. The Room Type as of now can only be the following values detailed above: D, Q, K, S, or C.
      3. Stay Credits Used should never be greater than the Stay Credits Earned 
      4. Customer Emailed - emails should have a character length of at least 7 or more. 
