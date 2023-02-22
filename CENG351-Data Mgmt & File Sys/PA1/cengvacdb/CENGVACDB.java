package ceng.ceng351.cengvacdb;

import java.sql.*;
import java.util.ArrayList;

import static ceng.ceng351.cengvacdb.Evaluation.connection;

public class CENGVACDB implements ICENGVACDB{
    private static String user = "e2414860"; // TODO: Your userName
    private static String password = "ISYl?gNH*B#5"; //  TODO: Your password
    private static String host = "144.122.71.121"; // host name
    private static String database = "db2414860"; // TODO: Your database name
    private static int port = 8080; // port

    private static Connection con = null;

    @Override
    public void initialize() {
        String url = "jdbc:mysql://" + host + ":" + port + "/" + database + "?useSSL=false";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con =  DriverManager.getConnection(url, user, password);
        }
        catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

    }

    @Override
    public int createTables() {
        int tableNum = 0;
        String CreateUserTable = "CREATE TABLE User ("
                + "userID INT NOT NULL,"
                + "userName VARCHAR(30) ,"
                + "age INT ,"
                + "address VARCHAR(150) ,"
                + "password VARCHAR(30) ,"
                + "status VARCHAR(15) ,"
                + "PRIMARY KEY (userID))";

        String CreateVaccineTable = "create table Vaccine (" +
                "code int not null," +
                "vaccinename varchar(30)," +
                "type varchar(30)," +
                "primary key (code))";

        String CreateVaccinationTable = "create table Vaccination (" +
                "code int not null," +
                "userID int not null," +
                "dose int not null," +
                "vacdate date," +
                "primary key (code,userID,dose),"+
                "foreign key (code) references Vaccine(code) ON DELETE CASCADE,"+
                "foreign key (userID) references User(userID))";

        String CreateAllergicSideEffectTable = "create table AllergicSideEffect (" +
                "effectcode int not null," +
                "effectname varchar(50)," +
                "primary key (effectcode))";

        String CreateSeenTable = "create table Seen (" +
                "effectcode int not null," +
                "code int not null," +
                "userID int not null," +
                "date date," +
                "degree varchar(30)," +
                "primary key (effectcode,code,userID),"+
                "foreign key (effectcode) references AllergicSideEffect(effectcode),"+
                "foreign key (code) references Vaccination(code) ON DELETE CASCADE,"+
                "foreign key (userID) references User(userID))";


        try {

            Statement statement = con.createStatement();

            //User Table
            statement.executeUpdate(CreateUserTable);
            tableNum++;

            //close
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try {

            Statement statement = con.createStatement();

            //Song Table
            statement.executeUpdate(CreateVaccineTable);
            tableNum++;

            //close
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try {

            Statement statement = con.createStatement();

            //artist Table
            statement.executeUpdate(CreateVaccinationTable);
            tableNum++;

            //close
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try {

            Statement statement = con.createStatement();

            //Album Table
            statement.executeUpdate(CreateAllergicSideEffectTable);
            tableNum++;

            //close
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try {

            Statement statement = con.createStatement();

            //Listen Table
            statement.executeUpdate(CreateSeenTable);
            tableNum++;

            //close
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tableNum;
    }

    @Override
    public int dropTables() {
        int result;
        int tablesDropped = 0;
        String[] tableNames = {"Seen", "Vaccination", "User", "AllergicSideEffect", "Vaccine"};
        String queryDropTable = "DROP TABLE IF EXISTS ";

        for(String tableN:tableNames) {
            try {
                String sql = queryDropTable  + tableN + ";";
                con.prepareStatement(sql).execute();
                tablesDropped++;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return tablesDropped;
    }

    @Override
    public int insertUser(User[] users) {
        int rowsIns = 0;

        for (User u: users) {
            try {
                String sql = "INSERT INTO User (userID, userName, age, address, password, status) VALUES (?, ?, ?, ?, ?, ?);";
                PreparedStatement statement = this.con.prepareStatement(sql);

                statement.setInt(1, u.getUserID());
                statement.setString(2, u.getUserName());
                statement.setInt(3, u.getAge());
                statement.setString(4, u.getAddress());
                statement.setString(5, u.getPassword());
                statement.setString(6, u.getStatus());

                statement.execute();

                rowsIns += 1;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return rowsIns;
    }

    @Override
    public int insertAllergicSideEffect(AllergicSideEffect[] sideEffects) {
        int rowsIns = 0;

        for (AllergicSideEffect a: sideEffects) {
            try {
                String sql = "INSERT INTO AllergicSideEffect (effectcode, effectname) VALUES (?, ?);";
                PreparedStatement statement = this.con.prepareStatement(sql);

                statement.setInt(1, a.getEffectCode());
                statement.setString(2, a.getEffectName());
                statement.execute();

                rowsIns += 1;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return rowsIns;
    }

    @Override
    public int insertVaccine(Vaccine[] vaccines) {
        int rowsIns = 0;

        for (Vaccine v: vaccines) {
            try {
                String sql = "INSERT INTO Vaccine (code, vaccinename, type) VALUES (?, ?, ?);";
                PreparedStatement statement = this.con.prepareStatement(sql);

                statement.setInt(1, v.getCode());
                statement.setString(2, v.getVaccineName());
                statement.setString(3, v.getType());

                statement.execute();

                rowsIns += 1;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return rowsIns;
    }

    @Override
    public int insertVaccination(Vaccination[] vaccinations) {
        int rowsIns = 0;

        for (Vaccination vac: vaccinations) {
            try {
                String sql = "INSERT INTO Vaccination (code, userID, dose, vacdate) VALUES (?, ?, ?, ?);";
                PreparedStatement statement = this.con.prepareStatement(sql);

                statement.setInt(1, vac.getCode());
                statement.setInt(2, vac.getUserID());
                statement.setInt(3, vac.getDose());
                statement.setString(4, vac.getVacdate());
                statement.execute();

                rowsIns += 1;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return rowsIns;
    }

    @Override
    public int insertSeen(Seen[] seens) {
        int rowsIns = 0;

        for (Seen s: seens) {
            try {
                String sql = "INSERT INTO Seen (effectcode, code, userID, date, degree) VALUES (?, ?, ?, ?, ?);";
                PreparedStatement statement = this.con.prepareStatement(sql);

                statement.setInt(1, s.getEffectcode());
                statement.setInt(2, s.getCode());
                statement.setInt(3, Integer.valueOf(s.getUserID()));
                statement.setString(4, s.getDate());
                statement.setString(5, s.getDegree());
                statement.execute();

                rowsIns += 1;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return rowsIns;
    }

    @Override
    public Vaccine[] getVaccinesNotAppliedAnyUser() {
        String query = "SELECT * FROM Vaccine V WHERE V.code NOT IN (SELECT V1.code FROM Vaccination V1) ORDER BY V.code;";
        ResultSet rs;
        ArrayList<Vaccine> resList = new ArrayList<Vaccine>();


        try {
            PreparedStatement statement = this.con.prepareStatement(query);
            rs =  statement.executeQuery();

            while (rs.next()) {
                resList.add(new Vaccine(
                        rs.getInt("code"),
                        rs.getString("vaccinename"),
                        rs.getString("type")
                ));
            }

            return resList.toArray(new Vaccine[0]);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return new Vaccine[0];
    }


    @Override
    public QueryResult.UserIDuserNameAddressResult[] getVaccinatedUsersforTwoDosesByDate(String vacdate) {


        String query = "SELECT DISTINCT U.userID, U.userName, U.address FROM User U WHERE U.userID IN (SELECT V1.userID FROM Vaccination V1,Vaccination V2  WHERE V1.vacdate > ? AND V2.vacdate > ? AND V1.userID = V2.userID AND V1.code = V2.code AND V1.dose = 1 AND V2.dose = 2) ORDER BY U.userID;";

        // SELECT * FROM User U
        //WHERE U.userID IN
        //(SELECT V1.userID FROM Vaccination V1,Vaccination V2
        //WHERE V1.vacdate > "2021-10-01" AND V2.vacdate > "2021-10-01"
        //AND V1.userID = V2.userID AND V1.code = V2.code AND V1.dose = 1 AND V2.dose = 2)
        //ORDER BY U.userID;//

        ResultSet rs;
        ArrayList<QueryResult.UserIDuserNameAddressResult> resList = new ArrayList<QueryResult.UserIDuserNameAddressResult>();


        try {
            PreparedStatement statement = this.con.prepareStatement(query);
            statement.setString(1, vacdate);
            statement.setString(2, vacdate);

            rs =  statement.executeQuery();



            while (rs.next()) {
                resList.add(new QueryResult.UserIDuserNameAddressResult(
                        rs.getString("userID"),
                        rs.getString("userName"),
                        rs.getString("address")
                ));
            }

            return resList.toArray(new QueryResult.UserIDuserNameAddressResult[0]);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new QueryResult.UserIDuserNameAddressResult[0];
    }

    @Override
    public Vaccine[] getTwoRecentVaccinesDoNotContainVac() {

        String query = "SELECT Temp.vaccinename, Temp.code , Temp.type FROM (SELECT V3.vaccinename, V3.code , V3.type ,max(VAC3.vacdate) as maxdate FROM Vaccine V3, Vaccination VAC3 WHERE V3.vaccinename NOT LIKE '%VAC%' AND V3.code = VAC3.code GROUP BY V3.vaccinename, V3.code , V3.type) as Temp ORDER BY Temp.maxdate DESC, Temp.code LIMIT 2;";

        ResultSet rs;
        ArrayList<Vaccine> resList = new ArrayList<Vaccine>();


        try {
            PreparedStatement statement = this.con.prepareStatement(query);
            rs =  statement.executeQuery();

            while (rs.next()) {
                resList.add(new Vaccine(
                        rs.getInt("code"),
                        rs.getString("vaccinename"),
                        rs.getString("type")
                ));
            }

            return resList.toArray(new Vaccine[0]);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return new Vaccine[0];
    }

    @Override
    public QueryResult.UserIDuserNameAddressResult[] getUsersAtHasLeastTwoDoseAtMostOneSideEffect() {
        String query = "SELECT * FROM User U WHERE U.userID IN  (SELECT V1.userID FROM Vaccination V1 WHERE V1.dose = 2) AND (U.userID NOT IN (SELECT S.userID FROM Seen S) OR U.userID NOT IN(SELECT S1.userID FROM Seen S1, Seen S2 Where S1.userID = S2.userID and S1.effectcode <> S2.effectcode )) ORDER BY U.userID;";

        ResultSet rs;
        ArrayList<QueryResult.UserIDuserNameAddressResult> resList = new ArrayList<QueryResult.UserIDuserNameAddressResult>();


        try {
            PreparedStatement statement = this.con.prepareStatement(query);
            rs =  statement.executeQuery();



            while (rs.next()) {
                resList.add(new QueryResult.UserIDuserNameAddressResult(
                        rs.getString("userID"),
                        rs.getString("userName"),
                        rs.getString("address")
                ));
            }

            return resList.toArray(new QueryResult.UserIDuserNameAddressResult[0]);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new QueryResult.UserIDuserNameAddressResult[0];
    }

    @Override
    public QueryResult.UserIDuserNameAddressResult[] getVaccinatedUsersWithAllVaccinesCanCauseGivenSideEffect(String effectname) {

        String query = "SELECT U.userID, U.userName, U.address FROM User U WHERE NOT EXISTS (SELECT DISTINCT S.code FROM Seen S, AllergicSideEffect A WHERE A.effectcode = S.effectcode and A.effectname = ? AND NOT EXISTS (SELECT V.code FROM Vaccination V WHERE V.userID = U.userID and V.code = S.code)) ORDER BY U.userID;";

        ResultSet rs;
        ArrayList<QueryResult.UserIDuserNameAddressResult> resList = new ArrayList<QueryResult.UserIDuserNameAddressResult>();

        try {
            PreparedStatement statement = this.con.prepareStatement(query);

            statement.setString(1, effectname);


            rs =  statement.executeQuery();



            while (rs.next()) {
                resList.add(new QueryResult.UserIDuserNameAddressResult(
                        rs.getString("userID"),
                        rs.getString("userName"),
                        rs.getString("address")
                ));
            }

            return resList.toArray(new QueryResult.UserIDuserNameAddressResult[0]);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new QueryResult.UserIDuserNameAddressResult[0];
    }

    @Override
    public QueryResult.UserIDuserNameAddressResult[] getUsersWithAtLeastTwoDifferentVaccineTypeByGivenInterval(String startdate, String enddate) {

        String query = "SELECT U.userID, U.userName, U.address FROM User U WHERE U.userID in  (SELECT V1.userID from Vaccination V1, Vaccination V2 where V1.vacdate >= ? and V1.vacdate <= ? and V2.vacdate >= ? and V2.vacdate <= ? and V1.userID = V2.userID and V1.code <> V2.code ) ORDER BY U.userID;";


        ResultSet rs;
        ArrayList<QueryResult.UserIDuserNameAddressResult> resList = new ArrayList<QueryResult.UserIDuserNameAddressResult>();

        try {
            PreparedStatement statement = this.con.prepareStatement(query);

            statement.setString(1, startdate);
            statement.setString(2, enddate);
            statement.setString(3, startdate);
            statement.setString(4, enddate);


            rs =  statement.executeQuery();



            while (rs.next()) {
                resList.add(new QueryResult.UserIDuserNameAddressResult(
                        rs.getString("userID"),
                        rs.getString("userName"),
                        rs.getString("address")
                ));
            }

            return resList.toArray(new QueryResult.UserIDuserNameAddressResult[0]);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new QueryResult.UserIDuserNameAddressResult[0];
    }

    @Override
    public AllergicSideEffect[] getSideEffectsOfUserWhoHaveTwoDosesInLessThanTwentyDays() {
        String query = "SELECT A.effectcode, A.effectname FROM Seen S, AllergicSideEffect A Where S.effectcode = A.effectcode and S.userID in (SELECT DISTINCT V1.userID from Vaccination V1, Vaccination V2 WHERE V1.userID = V2.userID and V1.code = V2.code and V1.dose < V2.dose and  DATEDIFF(V2.vacdate,V1.vacdate) < 20) ORDER BY A.effectcode;";

        ResultSet rs;
        ArrayList<AllergicSideEffect> resList = new ArrayList<AllergicSideEffect>();


        try {
            PreparedStatement statement = this.con.prepareStatement(query);
            rs =  statement.executeQuery();

            while (rs.next()) {
                resList.add(new AllergicSideEffect(
                        rs.getInt("effectcode"),
                        rs.getString("effectname")
                ));
            }

            return resList.toArray(new AllergicSideEffect[0]);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return new AllergicSideEffect[0];

    }

    @Override
    public double averageNumberofDosesofVaccinatedUserOverSixtyFiveYearsOld() {

        String query = "SELECT avg(T.AvgDose) FROM (SELECT V.userID , max(V.dose) as AvgDose FROM User U, Vaccination V Where V.userID = U.userID and U.age > 65 GROUP BY V.userID) as T;";

        ResultSet rs;
        double res = 0;

        try {
            PreparedStatement statement = this.con.prepareStatement(query);
            rs =  statement.executeQuery();
            while (rs.next()) {
                res = rs.getDouble("avg(T.AvgDose)");
            }
            return res;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return res;
    }

    @Override
    public int updateStatusToEligible(String givendate) {

        String query = "UPDATE User U SET status = \"eligible\" WHERE status <> \"Eligible\" and U.userID in (SELECT T.ID FROM (SELECT V.userID as ID , max(V.vacdate) as recentvac FROM Vaccination V GROUP BY V.userID) as T WHERE DATEDIFF(?,T.recentvac) >= 120);";

        try {
            PreparedStatement statement = this.con.prepareStatement(query);

            statement.setString(1, givendate);

            return statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public Vaccine deleteVaccine(String vaccineName) {

        String query = "SELECT * FROM Vaccine WHERE vaccinename = \"" + vaccineName + "\";";

        ResultSet rs;
        Vaccine delvac = null;

        try {

            PreparedStatement statement = this.con.prepareStatement(query);

            rs = statement.executeQuery(query);

            rs.next();

            delvac = new Vaccine(
                        rs.getInt("code"),
                        rs.getString("vaccinename"),
                        rs.getString("type"));

            statement.close();



        } catch (SQLException e) {
            e.printStackTrace();
        }

        query = "DELETE FROM Vaccine V WHERE V.vaccinename = \"" + vaccineName + "\";";

        try {

            Statement statement = con.createStatement();

            statement.executeUpdate(query);

            statement.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return delvac;

    }
}
