# -*- coding: utf-8 -*-

require 'csv'

#
# http://ykaku.com/ginkokensaku/index.php
# 「重複あり」をインポートする
#
namespace :bank do
  desc 'import "Zengin Code" csv database'
  task :import, [:csv_file_path] => :environment do |_, args|
    if args[:csv_file_path].blank? || !File.file?(args[:csv_file_path])
      fail('please obtain csv file from http://ykaku.com/ginkokensaku/index.php (ginkositen1.txt) and specify its path')
    end

    csv = CSV.open(args[:csv_file_path], 'rb:Windows-31J:UTF-8')
    csv.each do |row|
      bank_code        = row[0]
      bank_branch_code = row[1]
      kana             = row[2]
      name             = row[3]
      show_order       = row[5]

      case row[4]
        when "1"
          bank_or_branch   = :bank
        when "2"
          bank_or_branch   = :branch
        else
          raise 'unknown code: ' + row[4]
      end

      case bank_or_branch
        when :bank
          puts "bank: " + row.inspect
          bank = Bank.insert_or_update(bank_code, name, kana)
          if bank.errors.any?
            raise "invalid bank row: " + row.inspect + ", errors: " + bank.errors.inspect
          end
        when :branch
          puts "branch: " + row.inspect
          branch = BankBranch.insert_or_update(bank_code, bank_branch_code, name, kana, show_order)
          if branch.errors.any?
            raise "invalid branch row: " + row.inspect + ", errors: " + branch.errors.inspect
          end
        else
          raise
      end
    end
    csv.close
  end
end
