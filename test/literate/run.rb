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
      rest = rest.map {|exp| compile(exp) }.join("\n").gsub("\n", "\n  ")
      "describe #{title.inspect} do\n#{preamble}  #{rest}\nend\n"
    when :comment
      "# #{exp.last}"
    when :slim
      "it 'should render' do\n  slim = #{exp.last.inspect}"
    when :html
      "  html = #{exp.last.inspect}\n  assert_html html, slim\nend\n"
    end
  end

  def run
    puts @code
    eval(@code)
  end
end

LiterateTest.new(File.join(File.dirname(__FILE__), 'TESTS.md')).run
