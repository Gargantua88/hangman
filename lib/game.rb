require 'unicode_utils/upcase'
class Game
  attr_reader :status, :errors, :letters, :good_letters, :bad_letters

  def initialize(slovo)
    @letters = get_letters(slovo)
    @errors = 0
    @good_letters = []
    @bad_letters = []

    @status = :in_progress
  end

  def get_letters(slovo)
    if slovo == nil || slovo == ""
      abort "Загадано пустое слово, нечего отгадывать. Закрываемся"
    end

    UnicodeUtils.upcase(slovo).split("")
  end

  def next_step(bukva)
    return unless @status == :in_progress

    # Если введенная буква уже есть в списке "правильных" или "ошибочных" букв,
    # то ничего не изменилось, выходим из метода.
    return if @good_letters.include?(bukva) || @bad_letters.include?(bukva)

    if @letters.include?(bukva) ||
     (bukva == "Е" && letters.include?("Ё")) ||
     (bukva == "Ё" && letters.include?("Е")) ||
     (bukva == "И" && letters.include?("Й")) ||
     (bukva == "Й" && letters.include?("И"))

      @good_letters << bukva
      add_similar_letters(bukva, good_letters)

      @status = :win if (@letters.uniq.sort - @good_letters.uniq.sort).empty?
    else
      @bad_letters << bukva
      add_similar_letters(bukva, bad_letters)
      @errors += 1
      # Если ошибок больше 7 — статус игры меняем на -1, проигрыш.
      @status = :lose if @errors >= 7
    end
  end

  # Метод, спрашивающий юзера букву и возвращающий ее как результат.
  def ask_next_letter
    puts "\nВведите следующую букву"

    letter = ""
    letter = UnicodeUtils.upcase(STDIN.gets.encode("UTF-8").chomp) while letter == ""
    # После получения ввода, передаем управление в основной метод игры
    next_step(letter)
  end

  # Метод проверки и добавления похожих букв в массивы отгаданных и ошибочных
  def add_similar_letters(letter, array)
    case letter
    when "Е" then array << "Ё"
    when "Ё" then array << "Е"
    when "И" then array << "Й"
    when "Й" then array << "И"
    end
  end
end
