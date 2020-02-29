require 'zlib'
require 'chunky_png'

# Сторона идентикона в писелях
Size = 250
# Количество шагов сетки
Grid = 5
# Сторона шага сетки в пикселях
DSquare = Size / Grid

class Identicon
  attr_accessor :user_name, :path

# -- Переменные --
# user_name - имя пользователя
# path - путь для сохранения идентикона (опционально; по умолчанию - текущая локальная папка с расположением программы)
  def initialize(user_name, path = "C:/Programming/identicon_LT" )
    @user_name = user_name
    @path = path
  end

# Создание и сохранение идентикона пользователя
  def generate
    identicon_draw(image_arr(@user_name), @color)
    @image.save(@path+"/identicon_"+@id+".png")
  end

  private

  # кодирование никнейма пользователя и формирование правила построения изображения идентикона
   # -- Переменные --
   # rows - массив строк идентикона
   # @id - id пользователя для сохранения идентикона

    def image_arr(username)
      userhash = Zlib::crc32(username.downcase)
      @id = userhash.to_s(16)
      rows = []
      # разбор хэш - кода пользователя на форму и цвет идентикона
      Grid.times do
        rows.push(userhash & 31)
        userhash = (userhash >> Grid)
      end
      @color = color_convert(userhash)
      rows
    end

  # преобразование кода цвета 
    def color_convert(value)
      r = value % 4 * 63
      g = value / 4 % 4 * 63
      b = value / 8 % 8 * 31
      ChunkyPNG::Color.rgb(r, g, b)
    end

  # создание изображения идентикона
   # -- Переменные --
   # rows - массив строк идентикона (функция image_arr)

    def identicon_draw(rows, color)
      png = ChunkyPNG::Image.new(Size, Size, ChunkyPNG::Color::WHITE)
      rows.each_with_index do |y_item, y_index|
        bit_row(y_item).each_with_index do |x_item, x_index|
          if x_item == 1
            png.rect(x_index * DSquare, y_index * DSquare, (x_index + 1) * DSquare, (y_index + 1) * DSquare, color, color )
          end
        end
      end
      @image = png
    end

    # 
    def bit_row(num)
      bitrow = []
      Grid.times do
        bitrow.push(num % 2)
        num = (num >> 1)
      end
      bitrow
    end
end