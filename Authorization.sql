-- yetkilendirme
use kutuphane;
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'admin_password';
CREATE USER 'regular_user'@'localhost' IDENTIFIED BY 'regular_password';

GRANT ALL PRIVILEGES ON kutuphane.* TO 'admin_user'@'localhost';
GRANT SELECT ON kutuphane.* TO 'regular_user'@'localhost';

