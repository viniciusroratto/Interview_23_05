/*
javac -g -cp mysql-connector-java-8.0.25.jar; Main.java
java -cp mysql-connector-java-8.0.25.jar; Main
*/

import java.sql.*;
import java.util.jar.Attributes.Name;
import javax.swing.JOptionPane;

/* //////////////// //////////////// //////////////// */

class Main{
	
	private static final String url = "jdbc:mysql://@localhost:3306/laissezfaire";
	private static final String user = "root";
	private static final String password = "";
	private static Connection connection = null;
	private static Statement statement = null;
	private static ResultSet resultSet = null;

	/* //////////////// //////////////// //////////////// */
	
	public static void connect() throws SQLException {
		//Connection : represents an established database connection (session)
		//DriverManager : registers the driver for a specific database type
		//getConnection() : establishes a database connection
		//Statement : execute static SQL query
		connection = DriverManager.getConnection(url, user, password);
		statement = connection.createStatement();
	}//end of connect
	
	
	/* //////////////// //////////////// //////////////// */
	
	
	public static void query1() throws SQLException{
		
		resultSet = statement.executeQuery(
		"SELECT DISTINCT usuario.nome, COUNT(DISTINCT produto.cod_produto) FROM usuario JOIN fornecedor USING(cod_usuario) JOIN produto USING(cnpj) GROUP BY usuario.nome ORDER BY usuario.nome;"
		);
		
		System.out.println("QUERY 1: O nome do fornecedor e a quantidade de produtos distintos que cada fornecedor possui.");
		System.out.println("FORNECEDOR | QUANTIDADE PRODUTOS");
		
		while(resultSet.next()) {
			System.out.println(
					resultSet.getString(1) + " " +
					resultSet.getString(2)
			);
		}
	}//end of query1()
	
	public static void query2() throws SQLException{
		
		resultSet = statement.executeQuery(
		"SELECT DISTINCT usuario.nome, fornecedor.descricao_loja FROM usuario JOIN fornecedor USING(cod_usuario) JOIN produto USING(cnpj) GROUP BY usuario.nome HAVING SUM(produto.quantidade) < 20;"
		);
		
		System.out.println("QUERY 2: O nome do fornecedor e a descrição da sua loja apenas para fornecedores cujo número de produtos em estoque seja menor que 20.");
		
		while(resultSet.next()) {
			System.out.println(
					resultSet.getString(1) + " " +
					resultSet.getString(2)
			);
		}
	}//end of query2()
	
	
	public static void query3() throws SQLException{
		
		resultSet = statement.executeQuery(
		"SELECT DISTINCT usuario.nome, fornecedor.cnpj FROM usuario JOIN fornecedor USING(cod_usuario) JOIN produto USING(cnpj) JOIN categoria USING(cod_categoria) WHERE categoria.nome='ESPORTES' AND fornecedor.cnpj IN(SELECT DISTINCT fornecedor.cnpj FROM usuario JOIN fornecedor USING(cod_usuario) JOIN produto USING(cnpj) JOIN categoria USING(cod_categoria)	WHERE categoria.nome='VESTUARIO'); "
		);
		
		System.out.println("QUERY 3: Intersecção em MySQL: O nome e o cnpj de fornecedores que vendem artigos esportivos e peças de vestuário.");
		
		
		while(resultSet.next()) {
			System.out.println(
					resultSet.getString(1) + " " +
					resultSet.getString(2)
			);
		}
	}//end of query3()
	
	
	public static void query4() throws SQLException{
		
		resultSet = statement.executeQuery(
		"SELECT DISTINCT usuario.nome FROM usuario JOIN carrinho USING(cod_usuario) JOIN compra USING(cod_carrinho) JOIN produto USING(cod_produto) WHERE produto.total_gasto = (SELECT MAX(produto.total_gasto) FROM produto);"
		);
		
		System.out.println("QUERY 4: Condição sobre várias tuplas: O nome dos clientes que compraram o produto mais caro");
		
		while(resultSet.next()) {
			System.out.println(
					resultSet.getString(1)
			);
		}
	}//end of query4()
	
	
	public static void query5() throws SQLException{
		
		resultSet = statement.executeQuery(
		"SELECT usuario.nome FROM usuario JOIN fornecedor f USING(cod_usuario) WHERE NOT EXISTS (SELECT * FROM produto WHERE produto.cnpj = f.cnpj AND produto.cod_categoria IN ( SELECT DISTINCT produto.cod_categoria FROM usuario JOIN fornecedor USING (cod_usuario) JOIN produto USING(cnpj) WHERE usuario.nome = 'Biunapel Yp'));"
		);
		
		System.out.println("QUERY 5: O nome do(s) fornecedor(res) cujos produtos JAMAIS tem as mesmas categorias dos produtos de Biunapel Yp");
		
		while(resultSet.next()) {
			System.out.println(
					resultSet.getString(1)
			);
		}
	}//end of query5()
	
	
	/* //////////////// //////////////// //////////////// */
	
	public static void query6() throws SQLException{
		
		resultSet = statement.executeQuery(
			"SELECT DISTINCT categoria.nome AS 'Categoria', COUNT(DISTINCT v_ufornecedor.cnpj) AS 'Número de fornecedores'"
			+ " FROM categoria"
			+ " JOIN produto USING(cod_categoria)"
			+ " JOIN v_ufornecedor USING (cnpj)"
			+ " GROUP BY categoria.nome;"
		);//end of query6()
		
		System.out.println("QUERY 6: Para cada categoria, o número de fornecedores distintos que vendem produtos dessa categoria");
		
		while(resultSet.next()) {
			System.out.println(
					resultSet.getString(1)
			);
		}
	}

	public static void query7(int estrelas) throws SQLException{
		
		resultSet = statement.executeQuery(
			"SELECT DISTINCT v_ufornecedor.nome FROM v_ufornecedor JOIN produto USING(cnpj) JOIN avaliacao USING(cod_produto) WHERE avaliacao.estrelas='" + Integer.toString(estrelas) +  "';"
		);
		
		System.out.println("QUERY 7: os fornecedores que tiverem algum produto avaliado com 5 estrelas.");
		
		while(resultSet.next()) {
			System.out.println(
					resultSet.getString(1)
			);
		}
	}//end of query7()


	public static void query8(int total) throws SQLException{
		
		resultSet = statement.executeQuery(
			"SELECT DISTINCT pagamento.numero_cartao, usuario.email FROM usuario JOIN pagamento USING (cod_usuario) WHERE cod_usuario IN(SELECT DISTINCT cliente.cod_usuario FROM cliente WHERE cliente.total_gasto > " + Integer.toString(total) + ");"
		);
		
		System.out.println("QUERY 8: O numero do cartao e o email de clientes que gastaram mais que $1000");
		
		while(resultSet.next()) {
			System.out.println(
					resultSet.getString(1) + " " +
					resultSet.getString(2)
			);
		}
	}//end of query8()

	public static void query9(String name) throws SQLException{
		
		resultSet = statement.executeQuery(
			"SELECT DISTINCT pedido.cod_pedido, pedido.data_compra, pedido.data_entrega FROM pedido JOIN carrinho USING(cod_carrinho) JOIN usuario USING(cod_usuario) WHERE usuario.nome=+ '" + name + "';"
		);
		
		System.out.println("QUERY 9: O código, a data de compra e a data de entrega dos pedidos realizados por Jeff Obezos");
		
		while(resultSet.next()) {
			System.out.println(
					resultSet.getString(1) + " " +
					resultSet.getString(2) + " " +
					resultSet.getString(3)
			);
		}
	}//end of query9()

	public static void query10() throws SQLException{
		
		resultSet = statement.executeQuery(
			"SELECT DISTINCT endereco.bairro FROM endereco JOIN usuario USING( cod_usuario) JOIN carrinho USING(cod_usuario) JOIN compra USING(cod_carrinho) WHERE compra.quantidade >= (SELECT MAX(compra.quantidade) FROM compra);"
		);
		
		System.out.println("QUERY 10: o bairro dos clientes que compraram 5 ou mais unidades de um mesmo produto");
		
		while(resultSet.next()) {
			System.out.println(
					resultSet.getString(1)
			);
		}
	}//end of query10()
	
	/* //////////////// //////////////// //////////////// */
	
	public static void releaseResources()  throws SQLException{
		resultSet.close(); resultSet = null;
		statement.close(); statement = null;
		connection.close(); connection = null;
	}//end of releaseResources()
	
	/* //////////////// //////////////// //////////////// */
	
	public static void main(String argv[]) throws SQLException {
		
		int option = Integer.parseInt(argv[0]);
		
		switch(option){
			case 1:
				connect();
				query1();
				releaseResources();
			break;
			case 2:
				connect();
				query2();
				releaseResources();
			break;
			case 3:
				connect();
				query3();
				releaseResources();
			break;
			case 4:
				connect();
				query4();
				releaseResources();
			break;
			case 5:
				connect();
				query5();
				releaseResources();
			break;
			case 6:
				connect();
				query6();
				releaseResources();
			break;
			case 7:
				connect();
				query7(5);
				releaseResources();
			break;
			case 8:
				connect();
				query8(1000);
				releaseResources();
			break;
			case 9:
				connect();
				query9("Jeff Obezos");
				releaseResources();
			break;
			case 10: 
				connect();
				query10();
				releaseResources();
			break;
			default:
				System.out.println(argv[0] + " is an invalid option. Try a number between 1 and 10");
			break;
		}//end of switch
				
		//JOptionPane.showMessageDialog(null, "Success!");
	}//end of main()
}//end of class Main

/* //////////////// //////////////// //////////////// */
