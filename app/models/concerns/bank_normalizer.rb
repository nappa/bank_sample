# -*- coding: utf-8 -*-

module BankNormalizer
  class << self
    def normalize_bank_name(str, zengin_code)
      str = Moji.normalize_zen_han(str).strip

      if zengin_code.present? && (zengin_code < 1000 || zengin_code == 9900) && str !~ /銀行$/
        str + '銀行'
      else
        str
      end
    end

    def normalize_bank_name_kana(str)
      Moji.normalize_zen_han(str).strip.gsub('-', 'ー').gsub('.', '・')
    end

    def normalize_bank_branch_name(str)
      Moji.normalize_zen_han(str).strip
    end

    def normalize_bank_branch_name_kana(str)
      normalize_bank_name_kana(str)
    end
  end
end
