module Faker
  class BrazilianDocs < Base

    CPF_FIRST_MULTIPLIERS = [10, 9, 8, 7, 6, 5, 4, 3, 2]
    CPF_SECOND_MULTIPLIERS = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2]
    CPF_MAGIC_NUMBER = 11

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
        @cpf_first_array = Faker::BrazilianDocs.numerify("#########").scan(/./).map { |x| x.to_i }
        @first_verification_digit = nil
        @second_verification_digit = nil
        _calculate_verification_digits
      end

      def _calculate_verification_digits
        @first_verification_digit = _calculate_first_digit
        @cpf_first_array.push(@first_verification_digit)
        @second_verification_digit = _calculate_second_digit
        @cpf_first_array.push(@second_verification_digit)
      end

      def _calculate_first_digit
        remainder = _sum_digits % CPF_MAGIC_NUMBER

        if remainder < 2
          @first_verification_digit = 0
        else
          @first_verification_digit = CPF_MAGIC_NUMBER - remainder
        end
      end

      def _calculate_second_digit
        remainder = _sum_digits_again % CPF_MAGIC_NUMBER

        if remainder < 2
          @second_verification_digit = 0
        else
          @second_verification_digit = CPF_MAGIC_NUMBER - remainder
        end
      end

      def _sum_digits
        _multiple_each_digit.reduce(:+)
      end

      def _sum_digits_again
        _multiple_each_digit_again.reduce(:+)
      end

      def _multiple_each_digit
        @cpf_first_array.each_with_index.map do |n, index|
          n * CPF_FIRST_MULTIPLIERS[index]
        end
      end

      def _multiple_each_digit_again
        @cpf_first_array.each_with_index.map do |n, index|
          n * CPF_SECOND_MULTIPLIERS[index]
        end
      end

      def _return_valid_cpf_number
        @cpf_first_array.join("").to_i
      end

      def _return_invalid_cpf_number
        last_digit = @cpf_first_array.last

        if last_digit < 9
          last_digit = last_digit + 1
        else
          last_digit = last_digit - 1
        end

        @cpf_first_array[10] = last_digit
        @cpf_first_array.join("").to_i
      end
    end

  end
end
