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

    slovo.encode('UTF-8').downcase.split("")
  end

  def next_step(bukva)
    return unless @status == :in_progress

    # Если введенная буква уже есть в списке "правильных" или "ошибочных" букв,
    # то ничего не изменилось, выходим из метода.
    return if @good_letters.include?(bukva) || @bad_letters.include?(bukva)

    if @letters.include?(bukva) ||
     (bukva == "е" && letters.include?("ё")) ||
     (bukva == "ё" && letters.include?("е")) ||
     (bukva == "и" && letters.include?("й")) ||
     (bukva == "й" && letters.include?("и"))

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

    while letter == ""
      letter = STDIN.gets.encode("UTF-8").chomp.downcase
    end
    # После получения ввода, передаем управление в основной метод игры
    next_step(letter)
  end

  # Метод проверки и добавления похожих букв в массивы отгаданных и ошибочных
  def add_similar_letters(letter, array)
    case letter
    when "е" then array << "ё"
    when "ё" then array << "е"
    when "и" then array << "й"
    when "й" then array << "и"
    end
  end
end
