module Faker
  class BrazilianDocs < Base

    CPF_MULTIPLIERS = [10, 9, 8, 7, 6, 5, 4, 3, 2]
    CPF_MAGIC_NUMBER = 11
    @cpf_number_array = nil
    @first_verification_digit = nil

    class << self

      def valid_cpf
        _default_steps
        _return_valid_cpf_number
      end

      def invalid_cpf
        _default_steps
        _return_invalid_cpf_number
      end

      private

      def _default_steps
        _random_cpf_number_array
        _calculate_verification_digits
      end

      def _random_cpf_number_array
        Faker::BrazilianDocs.numerify("#########").scan(/./).map { |x| x.to_i }
      end

      def _calculate_verification_digits
        @cpf_number_array = _calculate_first_verification_digit
      end

      def _calculate_first_verification_digit
        remainder = _sum_multiplied_digits % CPF_MAGIC_NUMBER

        if remainder < 2
          @first_verification_digit = 0
        else
          @first_verification_digit = CPF_MAGIC_NUMBER - remainder
        end
      end

      def _sum_multiplied_digits
        _multiple_each_digit.reduce(:+)
      end

      def _multiple_each_digit
        _random_cpf_number_array.each_with_index do |n, index|
          n * CPF_MULTIPLIERS[index]
        end
      end

      def _return_valid_cpf_number
        @cpf_number_array.join("").to_i
      end

      def _return_invalid_cpf_number
        last_digit = @cpf_number_array.last

        if last_digit < 9
          last_digit = last_digit + 1
        else
          last_digit = last_digit - 1
        end

        @cpf_number_array[10] = last_digit
        @cpf_number_array.join("").to_i
      end
    end

  end
end
