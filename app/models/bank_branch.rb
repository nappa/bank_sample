# -*- coding: utf-8 -*-

class BankBranch < ActiveRecord::Base
  belongs_to :bank

  validates :bank_id,
            presence: true,
            inclusion: {
                in: Bank.pluck(:id)
            }

  validates :zengin_code,
            presence: true,
            format: {
                with:    /\A[0-9]*\z/,
                message: '数字で入力してください。',
            },
            numericality: {
                greater_than_or_equal_to: 0,
                less_than_or_equal_to: 999,
            },
            uniqueness: {
                scope: %i(bank_id show_order)
            }

  validates :name,
            presence: true,
            length: {
                maximum: 64,
            },
            format: {
                with: /\A\S+\z/,
            }

  validates :name_kana,
            presence: true,
            length: {
                maximum: 128,
            },
            format: {
                with: /\A[アァイィウゥヴエェオォカガキギクグケゲコゴサザシジスズセゼソゾタダチヂツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモヤユヨラリルレロワヲンーA-Za-z・]*\z/,
            }

  validates :show_order,
            numericality: { only_integer: true }

  class << self
    def search_bank_branch_by_name(any_string)
      # TODO 検索文を組み立てる
      # ※カナは促音無しへ正規化 + 「シテン」「ホンテン」「シユツチヨウシヨ」除去
      # ※「支店」「本店」除去
    end

    def search_bank_branch_by_zengin_code(zengin_bank_code, zengin_branch_code)
      self.includes(:bank)
          .where('banks.zengin_code = ?', zengin_bank_code)
          .where('bank_branches.zengin_code = ?', zengin_branch_code)
          .references(:bank)
    end

    def insert_or_update(zengin_bank_code, zengin_branch_code, name, name_kana, show_order)
      # 追記 or 更新するコードをここへ
      self.transaction do
        old = self.search_bank_branch_by_zengin_code(zengin_bank_code, zengin_branch_code)
        if old.any? && exist = old.find { |o| o.show_order == show_order }
          exist.name       = name
          exist.name_kana  = name_kana
          exist.show_order = show_order
          exist.save
          exist
        else
          bank = Bank.find_by_zengin_code(zengin_bank_code)
          unless bank
            raise "bank not found. zengin_code = " + zengin_bank_code.inspect
          end
          new = self.new
          new.bank_id     = bank.id
          new.zengin_code = zengin_branch_code
          new.name        = name
          new.name_kana   = name_kana
          new.show_order  = show_order
          new.save

          new
        end
      end
    end
  end

  def zengin_code_to_s
    "%03d" % self.zengin_code
  end

  # 正規化
  before_validation :normalize_name
  before_validation :normalize_name_kana

  private

  def normalize_name
    self.name = BankNormalizer.normalize_bank_branch_name(self.name)
  end

  def normalize_name_kana
    self.name_kana = BankNormalizer.normalize_bank_branch_name_kana(self.name_kana)
  end
end
