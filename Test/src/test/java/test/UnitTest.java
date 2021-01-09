package test;

import com.test.bean.Client;
import com.test.response.Response;
import com.test.service.IClientService;
import org.jboss.arquillian.container.test.api.Deployment;
import org.jboss.arquillian.junit.Arquillian;
import org.jboss.shrinkwrap.api.Archive;
import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.wildfly.swarm.undertow.WARArchive;

import javax.ejb.EJB;
import java.util.List;

import static org.junit.Assert.assertNotNull;

@RunWith(Arquillian.class)
public class UnitTest {

	@Deployment
	public static Archive<?> createDeployment() throws Exception {
		WARArchive archive = ShrinkWrap.create(WARArchive.class, "SampleTest.war");
		archive.addPackages(true, "com.test");
		return archive;
	}

	@EJB
	private IClientService man;

	@Test
	public void TestGetALL() {
		try {
			Response<List<Client>> clients = man.getAll();
			List<Client> clientList = (List<Client>) clients.getObject();
			assertNotNull(clientList);
		} catch (Exception e) {
			System.err.println("Error in TestGetALL --> " + e.getMessage());
		}
	}

}
