shared 'supporting ByteArray' do

  setup_test_environment

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'reading a ByteArray' do

    describe 'with automatic typecasting' do

      before do
        @reader = @connection.query("SELECT cad_drawing FROM widgets WHERE ad_description = ?", 'Buy this product now!')
        @values = @reader.first
      end

      it 'should return the correctly typed result' do
        @values.first.should.be.kind_of(DataObjects::ByteArray)
      end

      it 'should return the correct result' do
        @values.first.should == "CAD \001 \000 DRAWING"
      end

    end

    describe 'with manual typecasting' do

      before do
        @reader = @connection.query("SELECT cad_drawing FROM widgets WHERE ad_description = ?", 'Buy this product now!')
        @reader.set_types(DataObjects::ByteArray)
        @values = @reader.first
      end

      it 'should return the correctly typed result' do
        @values.first.should.be.kind_of(DataObjects::ByteArray)
      end

      it 'should return the correct result' do
        @values.first.should == "CAD \001 \000 DRAWING"
      end

    end

  end

  describe 'writing a ByteArray' do

    before do
      @reader = @connection.query("SELECT ad_description FROM widgets WHERE cad_drawing = ?", DataObjects::ByteArray.new("CAD \001 \000 DRAWING"))
      @values = @reader.first
    end

    it 'should return the correct entry' do
      #Some of the drivers starts autoincrementation from 0 not 1
      @values.first.should == 'Buy this product now!'
    end

  end

end
