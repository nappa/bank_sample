# -*- coding: utf-8 -*-

require 'pp'

class CreateBanks < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE `banks` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `zengin_code` smallint(6) NOT NULL,
        `name` varchar(64) NOT NULL,
        `name_kana` varchar(64)  NOT NULL,
        `created_at` datetime DEFAULT NULL,
        `updated_at` datetime DEFAULT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `index_banks_on_zengin_code` (`zengin_code`),
        UNIQUE KEY `index_banks_on_name` (`name`),
        KEY `index_banks_on_name_kana` (`name_kana`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    SQL

    execute <<-SQL
      CREATE TABLE `bank_branches` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `bank_id` int(11) NOT NULL,
        `zengin_code` smallint(6) NOT NULL,
        `name` varchar(64) NOT NULL,
        `name_kana` varchar(64) NOT NULL,
        `show_order` int(11) NOT NULL DEFAULT '1',
        `created_at` datetime DEFAULT NULL,
        `updated_at` datetime DEFAULT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `index_bank_branches_on_bank_id_and_zengin_code_and_show_order` (`bank_id`,`zengin_code`,`show_order`),
        UNIQUE KEY `index_bank_branches_on_bank_id_and_name` (`bank_id`,`name`),
        UNIQUE KEY `index_bank_branches_on_bank_id_and_name_kana` (`bank_id`,`name_kana`),
        KEY `index_bank_branches_on_name_kana` (`name_kana`),
        CONSTRAINT `fk_banks_bank_branches` FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`)
     ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
    SQL
  end

  def down
    [
        'ALTER TABLE bank_branches DROP FOREIGN KEY fk_banks_bank_branches;',
    ].each do |sql|
      execute sql
    end
    drop_table :banks, :bank_branches
  end
end
