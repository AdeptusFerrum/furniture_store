create table if not exists transit_status(
    transit_status_id serial not null constraint pk_transit_status_id primary key,
    transit_status_name varchar(36) not null 
        constraint uq_transit_status unique
        constraint chk_transit_status_name check (lower(transit_status_name) in ('в пути','завершён','ожидает сборку','отменён'))
);

create table if not exists courier(
    courier_id serial not null constraint pk_courier_id primary key,
    courier_surname varchar(36) not null,
    courier_name varchar(36) not null,
    courier_second_name varchar(36) null,
    courier_telephone varchar(16) not null
        constraint uq_courier_telephone unique
        constraint chk_courier_telephone check (courier_telephone ~'^(\+7|8)[\-]?\(?[0-9]{3}\)?[\-]?[0-9]{3}[\-]?[0-9]{2}[\-]?[0-9]{2}$')

);

create table if not exists Model_Automobile(
    Model_Automobile_id serial not null constraint pk_model_automobile_id primary key,
    Model_automobile_name varchar(50) not null 
        constraint uq_model_automobile unique
);
create table if not exists color_automobile(
    color_automobile_id serial not null constraint pk_color_automobile_id primary key,
    color_automobile_name varchar(36) not null
        constraint uq_color_automobile unique
);

create table if not exists mark_automobile(
    mark_automobile_id serial not null constraint mark_automobile_id primary key,
    mark_automobile_name varchar(36) not null
        constraint uq_mark_automobile_id unique
);

create table if not exists Product_Status (
    Product_Status_id serial not null constraint PK_Product_Status_ID primary key,
    Product_Status_Name varchar(50) not null
        constraint uq_product_status_name unique
        constraint chk_product_status_name check (lower(product_status_name) in ('есть в наличии','закончился','мало','много','среднее количество','очень мало'))
);

create table if not exists Users(
    users_id serial not null  constraint pk_users primary key,
    users_login varchar(36) not null
        constraint uq_users_login unique
        constraint chk_users_login check (users_login ~'^[a-zA-Z]$'),
    users_password varchar(255) not null
        constraint chk_users_password check(
        users_password ~ '[!@#$%^&*()_+-.~]' AND  
        users_password ~ '[A-Z]' AND          
        users_password ~ '[a-z]' AND          
        users_password ~ '[0-9]' AND          
        length(users_password) >= 8
        )
);

create table if not exists Storages(
    Storages_ID serial not null constraint PK_Storages_ID primary key,
    Storages_Number varchar(6) not null
        constraint uq_storages_number unique
        constraint chk_storage_number check (storages_number ~'^СОМБ[0-9]{2}$'),
    Storages_Address text not null
);

create table if not exists Material(
    Material_ID serial not null constraint PK_Material_ID primary key,
    Material_Name varchar(50) not null
        constraint uq_material_name unique
);

create table if not exists Order_Status(
    Order_Status_ID serial not null constraint PK_Order_Status_ID primary key,
    Order_Status_Name varchar(50) not null
        constraint uq_order_status_name unique
        constraint chk_order_status check (lower(order_status_name) in ('в сборке','отправлен','доставлен','отменён'))
);

create table if not exists Employee_Organization(
    Employee_Organization_ID serial not null constraint PK_Employee_Organization_Id primary key,
    Employee_Organization_Surname varchar(50) not null,
    Employee_Organization_Name varchar(50) not null,
    Employee_Organization_Second_Name varchar(50) null
);

create table if not exists Legal_Form(
    Legal_Form_ID serial not null constraint PK_Legal_Form_Id primary key,
    Legal_Form_Name varchar(5) not null
        constraint uq_legal_form unique
);

create table if not exists Type(
    Type_Id serial not null constraint PK_Type_Id primary key,
    Type_Name varchar(20) not null
        constraint uq_type_name unique
);

create table if not exists Country(
    Country_Id serial not null constraint pk_country_id primary key,
    Country_Name varchar(50) not null
        constraint uq_country_name unique
);

create table if not exists Mark(
    Mark_Id serial not null constraint pk_mark_id primary key,
    Country_Id int not null references Country(Country_ID),
    Mark_Name varchar(30) not null
);

create table if not exists Model(
    Model_ID serial not null constraint pk_model_id primary key,
    Mark_ID int not null references Mark(Mark_Id),
    Model_Name varchar(50) not null
        constraint uq_model_name unique
);

create table if not exists Product(
    Product_ID serial not null constraint PK_Product_ID primary key,
    Model_ID int not null references Model(Model_Id),
    Type_ID int not null references Type(Type_Id),
    Product_Article varchar(11) not null
        constraint uq_product_article unique
        constraint chk_product_article check(product_article~'^ИЗД№[0-9]{7}$'),
    Product_Price decimal(12,2) not null
        constraint chk_product_price check (product_price>=0),
    Product_Length int not null
        constraint chk_product_length check (product_length>0),
    Product_Width int not null
        constraint chk_product_width check (product_width>0),
    Product_Height int not null
        constraint chk_product_height check (product_height>0),
    Product_Description text null,
    Product_Photo varchar(100) null
);

create table if not exists Product_Material(
    Product_Material_ID serial not null constraint pk_product_material_key primary key,
    Product_Id int references Product(Product_ID),
    Material_Id int references Material(Material_Id)
);

create table if not exists Product_Avaliable(
    Proudct_Avaliable_ID serial not null constraint product_avaliable_id primary key,
    Product_ID int references Product(Product_ID),
    Product_Status_ID int references Product_Status(Product_Status_Id),
    Storages_ID int references Storages(Storages_ID),
    Product_Avaliable_Count int not null
        constraint chk_product_avaliable_Count check (Product_Avaliable_Count>=0)
);

create table if not exists Manufacturer (
    Manufacturer_ID serial not null constraint pk_manufacturer_id primary key,
    Legal_Form_ID int not null references Legal_Form(Legal_Form_ID),
    Manufacturer_Name varchar(50) not null
        constraint uq_manufacturer_name unique,
    Manufacturer_Address text not null,
    Manufacturer_Legal_Address text not null,
    Manufacturer_TIN varchar(10) not null
        constraint uq_manufacturer_tin unique,
    Manufacturer_OKPO varchar(10) not null
        constraint chk_manufacturer_okpo check(manufacturer_okpo ~ '^[0-9]{8}$' OR manufacturer_okpo ~ '^[0-9]{10}$'),
    Manufacturer_BIC varchar(9) not null
        constraint chk_manufacturer_bic check(manufacturer_bic ~'^[0-9]{9}$')
);

create table if not exists Estimate(
    Estimate_Id serial not null constraint pk_estimate_id primary key,
    Manufacturer_id int not null references Manufacturer(Manufacturer_ID),
    Employee_Organization_Id int not null references Employee_Organization(Employee_Organization_ID),
    Estimate_Number varchar(14) not null
        constraint uq_estimate_number unique
        constraint chk_estimate_number check(estimate_number ~'^ДСТ-[0-9]{7}-[0-9]{2}$'),
    Estimate_Date date not null
);

create table if not exists Estimate_Content(
    Estimate_Content_ID serial not null constraint pk_estimate_content_id primary key,
    Estimate_ID int not null references Estimate(EStimate_id),
    Product_ID int not null references Product(Product_ID),
    Estimate_Content_Count int not null 
        constraint chk_estimate_content_count check (estimate_content_count>0)
);

create table if not exists Defective_Elements(
    Defective_Elements_ID serial not null constraint pk_defective_elements_id primary key,
    Estimate_Content_Id int not null references Estimate_Content(Estimate_Content_ID),
    Defective_Elements_name varchar(50) not null
);

create table if not exists Delivery(
    Delivery_ID serial not null constraint pk_delivery_id primary key,
    Estimate_Id int not null references Estimate(Estimate_Id),
    Delivery_number varchar(17) not null 
        constraint uq_delivery_number unique
        constraint chk_delivery_number check(delivery_number ~ 'АТП/[0-9]{2}-[0-9]{10}'),
    Delivery_date date not null,
    Delivery_time time not null
);

create table if not exists Employee_Post(
    Employee_Post_id serial not null constraint pk_employee_post_id primary key,
    Employee_Post_name varchar(50) not null
        constraint uq_employee_post unique
);

create table if not exists Employee(
    Employee_id serial not null constraint pk_employee_id primary key,
    Employee_Post_ID serial not null,
    Employee_Surname varchar(50) not null,
    Employee_Name varchar(50) not null,
    Employee_Second_Name varchar(50) null,
    Employee_Telephone varchar(16) not null
        constraint uq_telephone_number unique
        constraint chk_employee_telephone check(employee_telephone ~'^(\+7|8)[\-]?\(?[0-9]{3}\)?[\-]?[0-9]{3}[\-]?[0-9]{2}[\-]?[0-9]{2}$')
);

create table if not exists Employee_Auth(
    Employee_Auth_Id serial not null constraint pk_employee_auth_id primary key,
    Employee_Id int unique not null references Employee(Employee_ID),
    Users_id int unique not null  references Users(users_id)
);

create table if not exists customers_org(
    customers_org_id serial not null constraint pk_customers_org_id primary key,
    legal_form_id int not null references Legal_Form(legal_form_id),
    customers_org_full_name text not null
        constraint uq_customers_org_full_name unique,
    customers_org_abbreviated_name varchar(50) not null,
    customers_org_address text not null
);

create table if not exists orderr(
    order_id serial not null constraint pk_order_id primary key,
    employee_id int not null references employee(employee_id),
    order_status_id int not null references order_status(order_status_id),
    customers_org_id int not null references customers_org(customers_org_id),
    order_number varchar(16) not null
        constraint uq_order_number unique
        constraint chk_check_number check(order_number ~'ЗК/П/[0-9]{11}'),
    order_date date not null,
    order_time time not null,
    order_price decimal(12,2) not null
        constraint chk_order_price check (order_price >=0)
);

create table if not exists agent_post(
    agent_post_id serial not null constraint pk_agent_post_id primary key,
    agent_post_name varchar(50) not null
        constraint uq_agent_post unique
);


create table if not exists agent(
    agent_id serial not null constraint pk_agent_id primary key,
    agent_post_id int not null references agent_post(agent_post_id),
    customers_org_id int not null references customers_org(customers_org_id),
    agent_surname varchar(50) not null,
    agent_name varchar(50) not null,
    agent_second_name varchar(50) null,
    agent_passport_series varchar(4) not null
        constraint uq_agent_passport_seris unique,
    agent_passport_number varchar(6) not null
        constraint uq_agent_passport_number unique,
    agent_telephone varchar(16) not null
        constraint uq_agent_telephone unique
        constraint chk_agent_telephone check (agent_telephone ~'^(\+7|8)[\-]?\(?[0-9]{3}\)?[\-]?[0-9]{3}[\-]?[0-9]{2}[\-]?[0-9]{2}$'),
    agent_email text null
        constraint chk_agent_email check(agent_email ~ '@.')
);

create table if not exists agent_auth (
    agent_auth_id serial not null constraint pk_agent_auth_id primary key,
    users_id int not null references users(users_id),
    agent_id int not null references agent(agent_id)
);


create table if not exists Order_Check(
    Order_Check_id serial not null constraint pk_order_check_id primary key,
    Order_Id int not null references orderr(order_id),
    Order_Check_Number varchar(14) not null 
        constraint UQ_Order_Check unique
        constraint chk_order_check_number check (order_check_number ~'КЧ-П-[0-9]{9}'),
    Order_Check_Price decimal(12,2) not null
        constraint chk_order_check_price check (order_check_price >=0),
    Order_Check_date date not null,
    Order_Check_time time not null
);

create table if not exists Order_Content(
    Order_content_id serial not null constraint pk_order_content_id primary key,
    order_id int not null references orderr(order_id),
    product_id int not null references product(product_id),
    order_content_count int not null
        constraint chk_order_content_count check (order_content_count>0),
    order_content_price decimal(12,2) not null
        constraint chk_order_content_price check (order_content_price>=0)
);

create table if not exists region_automobile(
    region_automobile_id serial not null constraint pk_region_automobile_id primary key,
    region_automobile_number varchar(6) constraint uq_region_automobile_number unique
);

create table if not exists automobile(
    automobile_id serial not null constraint pk_automobile_id primary key,
    mark_automobile_id int not null references mark_automobile(mark_automobile_id),
    model_automobile_id int not null references model_automobile(model_automobile_id),
    color_automobile_id int not null references color_automobile(color_automobile_id),
    region_automobile int not null references region_automobile(region_automobile_id),
    automobile_number varchar(6) not null 
        constraint uq_automobile_number unique
        constraint chk_automobile_number check(automobile_number ~'^[а-яА-Я]{1}[0-9]{3}[а-яА-Я]{2}$')
);

create table if not exists transit(
    transit_id serial not null constraint pk_transit_id primary key,
    transit_status_id int not null references transit_status(transit_status_id),
    order_id int not null references orderr(order_id),
    automobile_id int not null references automobile(automobile_id),
    courier_id int not null references courier(courier_id),
    transit_number varchar(16) not null 
        constraint uq_tranist_numbee unique
        constraint chk_transit_number check(transit_number ~ '^МЛ-[0-9]{2}-[0-9]{10}$'),
    transit_date date not null
        constraint chk_transit_date check (transit_date <= transit_send),
    transit_time time not null, 
    transit_send date not null
        constraint chk_transit_send check (transit_send >= transit_date),
    transit_arrive date not null
        constraint chk_transit_arrive check (transit_arrive>=transit_send),
    transit_arrive_time time not null
);