DELIMITER $$

DROP FUNCTION IF EXISTS `url_decode` $$
CREATE DEFINER=`root`@`%` FUNCTION `url_decode`(original_text text) RETURNS text CHARSET utf8
BEGIN
	declare new_text text default null;
	declare pointer int default 1;
	declare end_pointer int default 1;
	declare encoded_text text default null;
	declare result_text text default null;
	
	SET new_text = replace(original_text,'+',' ');
	
	SET pointer = LOCATE("%", new_text);
	while pointer <> 0 && pointer < (char_length(new_text) - 2) do
		SET end_pointer = pointer + 3;
		while mid(new_text, end_pointer, 1) = "%" do
			SET end_pointer = end_pointer+3;
		end while;
	
		SET encoded_text = mid(new_text, pointer, end_pointer - pointer);
		SET result_text = convert(unhex(REPLACE(encoded_text, "%", "")) using utf8);
		SET new_text = REPLACE(new_text, encoded_text, result_text);
		SET pointer = LOCATE("%", new_text, pointer + char_length(result_text));
	end while;
	
	return new_text;
	
END $$

DELIMITER ;