STATS_DIRECTORIES = [
  %w(Controllers        app/controllers),
  %w(Helpers            app/helpers),
  %w(Models             app/models),
  %w(Mailers            app/mailers),
  %w(Javascripts        app/assets/javascripts),
  %w(Libraries          lib/),
  %w(APIs               app/apis),
  %w(Controller\ tests  test/controllers),
  %w(Helper\ tests      test/helpers),
  %w(Model\ tests       test/models),
  %w(Mailer\ tests      test/mailers),
  %w(Integration\ tests test/integration),
  %w(Functional\ tests\ (old)  test/functional),
  %w(Unit\ tests \ (old)       test/unit)
].collect { |name, dir| [ name, "#{Rails.root}/#{dir}" ] }.select { |name, dir| File.directory?(dir) }

desc "Report code statistics (KLOCs, etc) from the application"
task :stats do
  require 'rails/code_statistics'
  CodeStatistics.new(*STATS_DIRECTORIES).to_s
end


class CodeStatistics #:nodoc:

  TEST_TYPES = ['Controller tests',
                'Helper tests',
                'Model tests',
                'Mailer tests',
                'Integration tests',
                'Functional tests (old)',
                'Unit tests (old)']

  def initialize(*pairs)
    @pairs      = pairs
    @statistics = calculate_statistics
    @total      = calculate_total if pairs.length > 1
  end

  def to_s
    print_header
    @pairs.each { |pair| print_line(pair.first, @statistics[pair.first]) }
    print_splitter

    if @total
      print_line("Total", @total)
      print_splitter
    end

    print_code_test_stats
  end

  private
  def calculate_statistics
    Hash[@pairs.map{|pair| [pair.first, calculate_directory_statistics(pair.last)]}]
  end

  def calculate_directory_statistics(directory, pattern = /.*\.(rb|js|coffee)$/)
    stats = CodeStatisticsCalculator.new

    Dir.foreach(directory) do |file_name|
      path = "#{directory}/#{file_name}"

      if File.directory?(path) && (/^\./ !~ file_name)
        stats.add(calculate_directory_statistics(path, pattern))
      end

      next unless file_name =~ pattern

      stats.add_by_file_path(path)
    end

    stats
  end

  def calculate_total
    @statistics.each_with_object(CodeStatisticsCalculator.new) do |pair, total|
      total.add(pair.last)
    end
  end

  def calculate_code
    code_loc = 0
    @statistics.each { |k, v| code_loc += v.code_lines unless TEST_TYPES.include? k }
    code_loc
  end

  def calculate_tests
    test_loc = 0
    @statistics.each { |k, v| test_loc += v.code_lines if TEST_TYPES.include? k }
    test_loc
  end

  def print_header
    print_splitter
    puts "| Name                 | Lines |   LOC | Classes | Methods | M/C | LOC/M |"
    print_splitter
  end

  def print_splitter
    puts "+----------------------+-------+-------+---------+---------+-----+-------+"
  end

  def print_line(name, statistics)
    m_over_c   = (statistics.methods / statistics.classes) rescue m_over_c = 0
    loc_over_m = (statistics.code_lines / statistics.methods) - 2 rescue loc_over_m = 0

    puts "| #{name.ljust(20)} " \
    "| #{statistics.lines.to_s.rjust(5)} " \
    "| #{statistics.code_lines.to_s.rjust(5)} " \
    "| #{statistics.classes.to_s.rjust(7)} " \
    "| #{statistics.methods.to_s.rjust(7)} " \
    "| #{m_over_c.to_s.rjust(3)} " \
    "| #{loc_over_m.to_s.rjust(5)} |"
  end

  def print_code_test_stats
    code  = calculate_code
    tests = calculate_tests

    puts "  Code LOC: #{code}     Test LOC: #{tests}     Code to Test Ratio: 1:#{sprintf("%.1f", tests.to_f/code)}"
    puts ""
  end
end

class CodeStatisticsCalculator #:nodoc:
  attr_reader :lines, :code_lines, :classes, :methods

  PATTERNS = {
    rb: {
      line_comment: /^\s*#/,
      begin_block_comment: /^=begin/,
      end_block_comment: /^=end/,
      class: /^\s*class\s+[_A-Z]/,
      method: /^\s*def\s+[_a-z]/,
    },
    js: {
      line_comment: %r{^\s*//},
      begin_block_comment: %r{^\s*/\*},
      end_block_comment: %r{\*/},
      method: /function(\s+[_a-zA-Z][\da-zA-Z]*)?\s*\(/,
    },
    coffee: {
      line_comment: /^\s*#/,
      begin_block_comment: /^\s*###/,
      end_block_comment: /^\s*###/,
      class: /^\s*class\s+[_A-Z]/,
      method: /[-=]>/,
    }
  }

  def initialize(lines = 0, code_lines = 0, classes = 0, methods = 0)
    @lines = lines
    @code_lines = code_lines
    @classes = classes
    @methods = methods
  end

  def add(code_statistics_calculator)
    @lines += code_statistics_calculator.lines
    @code_lines += code_statistics_calculator.code_lines
    @classes += code_statistics_calculator.classes
    @methods += code_statistics_calculator.methods
  end

  def add_by_file_path(file_path)
    File.open(file_path) do |f|
      self.add_by_io(f, file_type(file_path))
    end
  end

  def add_by_io(io, file_type)
    patterns = PATTERNS[file_type] || {}

    comment_started = false

    while line = io.gets
      @lines += 1

      if comment_started
        if patterns[:end_block_comment] && line =~ patterns[:end_block_comment]
          comment_started = false
        end
        next
      else
        if patterns[:begin_block_comment] && line =~ patterns[:begin_block_comment]
          comment_started = true
          next
        end
      end

      @classes   += 1 if patterns[:class] && line =~ patterns[:class]
      @methods   += 1 if patterns[:method] && line =~ patterns[:method]
      if line !~ /^\s*$/ && (patterns[:line_comment].nil? || line !~ patterns[:line_comment])
        @code_lines += 1
      end
    end
  end

  private
  def file_type(file_path)
    File.extname(file_path).sub(/\A\./, '').downcase.to_sym
  end
end
