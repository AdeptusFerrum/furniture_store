create role rl_order_manager with password 'Password';
alter role rl_order_manager LOGIN;
grant connect on database furniture_store to rl_order_manager;

create role rl_supplier_manager with password 'Password';
alter role rl_supplier_manager with LOGIN;
grant connect on database furniture_store to rl_supplier_manager;

create role rl_manufacturer with password 'Password';
alter role rl_manufacturer with LOGIN;
grant connect on database furniture_store to rl_manufacturer;

create role rl_agent with password 'Password';
alter role rl_agent with LOGIN;
grant connect on database furniture_store to rl_agent;

create role rl_customers with password 'Password';
alter role rl_customers with LOGIN;
grant connect on database furniture_store to rl_customers;

create role rl_administrator with password 'Password';
alter role rl_administrator with LOGIN;
grant connect on database furniture_store to rl_administrator;

create role rl_courier with password 'Password';
alter role rl_courier with LOGIN;
grant connect on database furniture_store to rl_courier;

