class LiterateTest
  def initialize(file)
    lines = File.readlines(file)
    exp = parse(lines)
    @code = "require 'helper'\n\n" + compile(exp, "  include Helper\n\n")
  end

  def parse(lines)
    stack = []
    until lines.empty?
      line = lines.shift
      case line
      when /\A(#+)\s*(.*)\Z/
        while stack.size >= $1.size
          stack.pop
        end
        exp = [:section, $2]
        stack.last << exp if stack.last
        stack << exp
      when /\A~{3,}\s*(\w+)\s\Z/
        lang = $1
        block = []
        until lines.empty?
          line = lines.shift
          case line
          when /\A~{3,}\Z/
            break
          when /\A.*\Z/
            block << $&
          end
        end
        stack.last << [lang.to_sym, block.join("\n")]
      when /\A\s+\Z/
      when /\A.*\Z/
        stack.last << [:comment, $&]
      end
    end
    stack.first
  end

  def compile(exp, preamble = '')
    case exp.first
    when :section
      type, title, *rest = exp
      slim = rest.count {|exp| exp.first == :slim }
      html = rest.count {|exp| exp.first == :html }
      rest = rest.map {|exp| compile(exp) }.join("\n").gsub("\n", "\n  ")
      if html > 0 && slim > 0
        raise "You need exactly one slim and one html block per test case" unless html == 1 && slim == 1
        "it #{title.inspect} do\n  #{rest}\n  assert_html html, slim\nend\n"
      else
        "describe #{title.inspect} do\n#{preamble}  #{rest}\nend\n"
      end
    when :comment
      "# #{exp.last}"
    when :slim, :html
      "#{exp.first} = #{exp.last.inspect}"
    end
  end

  def run
    puts @code
    eval(@code)
  end
end

LiterateTest.new(File.join(File.dirname(__FILE__), 'TESTS.md')).run
