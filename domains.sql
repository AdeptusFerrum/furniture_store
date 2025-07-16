create DOMAIN telephone_type as text
check(
    value ~'^(\+7|8)[\-]?\(?[0-9]{3}\)?[\-]?[0-9]{3}[\-]?[0-9]{2}[\-]?[0-9]{2}$'
);

create domain email_type as text
check (
    value ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    and length(value) <= 254  
);

create domain login_type as text
check (
    length(value) between 6 and 64
    and value ~ '^[a-zA-Z0-9._-]+$'
    and value ~ '^[a-zA-Z]'
    and value !~ '\.\.'
    and value !~ '[\.\-]$'
);

create domain password_hash as text
check(
    length(value) between 60 and 128
);

create domain inn_type as text
check (
    value ~ '^\d{10}$' or  
    value ~ '^\d{12}$'     
);

create domain bic_type as text
check (value ~'^\d{9}$');

create domain okpo_type as text
check(value~'^\d{8,10}$');

create domain legal_form_type as text
check (
    value in (
        'ИП','ПАО','АО','ООО',
        'НКО','АНО','Фонд','ПК',
        'ГУП','МУП','КФХ','ТСЖ'
    )
);

